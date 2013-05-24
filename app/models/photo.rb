require 'zip/zip'
class Photo < ActiveRecord::Base
  attr_accessible :image, :vehicle_id, :vehicles_photo_id, :active, :deleted_at
  belongs_to :vehicle

  before_destroy :deactivate

  has_attached_file :image, styles: { thumb: '150x150#' }
  validates_attachment :image, presence: {message: 'must be chosen before saving'}
	validates_attachment :image, content_type: {content_type: ['image/jpeg','image/jpg','image/png','image/gif','application/zip']}
  before_post_process :image?
  before_create :set_vehicles_photo_id
	before_save :detect_zipped_file
  after_save :remove_zipped_file

  def activate
    update_attributes active: true, deleted_at: nil
  end

  def image?
    image_content_type != 'application/zip'
  end

  private
  def set_vehicles_photo_id
    self.vehicles_photo_id = (vehicle.photos.maximum(:vehicles_photo_id)|| 0) + 1
	end

	def detect_zipped_file
		if image_content_type == 'application/zip'
			puts 'Inspect tempfiles...'
			Zip::ZipFile.open(image.queued_for_write[:original].path) do |zipfile|
				zipfile.each do |entry|
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

  def remove_zipped_file
    unless image?
      puts "\n\n destroying zipped file: #{image_file_name}\n\n\n"
      destroy
    end
  end

  def deactivate
    if image?
      update_attributes({ active: false, deleted_at: Time.now })
      false
    else
      true
    end
  end
end