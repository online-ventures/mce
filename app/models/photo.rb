require 'zip/zip'
class Photo < ActiveRecord::Base
  # populates deleted_at, and prevents deletion
  acts_as_paranoid
  attr_accessible :image, :vehicle_id, :vehicles_photo_id, :deleted_at, :featured?
  belongs_to :vehicle, touch: true

  has_attached_file :image, styles: { thumb: '150x150#' }
  validates_attachment :image, presence: {message: 'must be chosen before saving'}
	validates_attachment :image, content_type: {content_type: ['image/jpeg','image/jpg','image/png','image/gif','application/zip']}
  before_post_process :image?
  before_create :set_vehicles_photo_id
	before_save :detect_zipped_file
  after_save :remove_zipped_file

  scope :active, where(deleted_at: nil)
  scope :inactive, where('deleted_at IS NOT NULL')

  def image?
    image_content_type != 'application/zip'
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

  def activate
    update_attribute :deleted_at, nil
  end

  private
  def set_vehicles_photo_id
    self.vehicles_photo_id = (vehicle.photos.maximum(:vehicles_photo_id)|| 0) + 1
  end

	def detect_zipped_file
		if image_content_type == 'application/zip'
			Zip::ZipFile.open(image.queued_for_write[:original].path) do |zipfile|
				zipfile.each do |entry|
          unless entry.name.match(/^(\.||\_||\.\.||\_\_)+(MACOSX)?(DS_Store)?\/?(\._.*)?$/)
					  tempfile = Tempfile.new([File.basename(entry.name, File.extname(entry.name)),File.extname(entry.name)], '/tmp')
					  tempfile.binmode
					  tempfile.write entry.get_input_stream.read
            File.rename(tempfile.path , '/tmp/'+entry.name)

            photo = Photo.new
					  photo.vehicle_id = vehicle_id
					  photo.image = File.open('/tmp/'+entry.name)
					  photo.save!
          end
				end
      end
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