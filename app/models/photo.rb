require 'zip'
class Photo < ApplicationRecord
  # populates deleted_at, and prevents deletion
  belongs_to :vehicle, touch: true

  # Paperclip
  has_attached_file :image

  # Active storage
  has_one_attached :file

  # Validation
  validates_attachment :image, presence: {message: 'must be chosen before saving'}
  validates_is_photo_or_zip :image

  # Callbacks
  before_post_process :image?
  before_create :set_vehicles_photo_id
  before_save :detect_zipped_file
  after_save :remove_zipped_file

  # scopes
  scope :active, -> { where(deleted_at: nil) }
  scope :inactive, -> { where('deleted_at IS NOT NULL') }
  scope :prioritize_id, ->(id) { order("id = '#{id || 0}' DESC, id ASC") } # put featured first, then normal sort

  def image?
    image_content_type =~ /^image\/(png|gif|jpe?g)$/
  end

  def zip?
    image_file_name =~ /^.*\.zip$/
  end

  def vehicle
    Vehicle.unscoped{ super }
  end

  def featured?
    if self.vehicle
      self.id == self.vehicle.featured_id
    else
      false
    end
  end

  def self.purge_old_photos
    unscoped.joins(:vehicle).where('"vehicles".deleted_at < ?', 6.months.ago).each do |photo|
      photo.delete_image_and_record
    end
  end

  def delete_image_and_record
    self.image = nil
    save
    destroy
  end

  private
  def set_vehicles_photo_id
    self.vehicles_photo_id = (vehicle.photos.maximum(:vehicles_photo_id)|| 0) + 1
  end

  def detect_zipped_file
    if zip?
      @vehicle ||= vehicle
      Zip::InputStream.open(image.queued_for_write[:original].path) do |io|
        # We need to catch the first "next_entry"
        # because this is actually the last file
        # inside the zip, and file order is important
        entries = []
        last = io.get_next_entry
        while entry = io.get_next_entry
          entries.push entry
        end
        entries.push last
        entries.each do |entry|
          unless entry.name.match(/^(\.||\_||\.\.||\_\_)+(MACOSX)?(DS_Store)?\/?(\._.*)?$/)
            tempfile = Tempfile.new([File.basename(entry.name, File.extname(entry.name)),File.extname(entry.name)], '/tmp')
            tempfile.binmode
            tempfile.write entry.get_input_stream.read
            File.rename(tempfile.path , '/tmp/'+entry.name)

            photo = @vehicle.photos.new({image: File.open('/tmp/'+entry.name) })
            photo.save!
          end
        end
      end
      self.image_content_type = 'application/zip'
    end
  end

  def remove_zipped_file
    Photo.unscoped.where(image_content_type: 'application/zip').delete_all
  end

  # Overrides Paperclip methods which delete images, and image data
  def destroy_attached_files
    true
  end
  def prepare_for_destroy
    true
  end
end
