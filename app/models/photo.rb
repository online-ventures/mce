require 'zip/zip'
class Photo < ActiveRecord::Base
  attr_accessible :image, :vehicle_id, :vehicles_photo_id
  belongs_to :vehicle
  has_attached_file :image

	validates_attachment :image, presence: {message: 'must be chosen before saving'}
	validates_attachment :image, content_type: {content_type: ['image/jpeg','image/jpg','image/png','image/gif','application/zip']}

  before_create :set_vehicles_photo_id
	before_save :detect_zipped_file

  def set_vehicles_photo_id
    self.vehicles_photo_id = vehicle.photos.count + 1
	end

	def detect_zipped_file
		if image_content_type == 'application/zip'
			puts 'Inspect tempfiles...'
			Zip::ZipFile.open(image.queued_for_write[:original].path) do |zipfile|
				zipfile.each do |entry|
					tempfile = Tempfile.new([File.basename(entry.name),File.extname(entry.name)])
					tempfile.binmode
					tempfile.write entry.get_input_stream.read
					tempfile.original_filename = entry.name
					puts tempfile.inspect

					photo = Photo.new
					photo.vehicle_id = vehicle_id
					photo.image = tempfile
					photo.save
				end
			end
			false
		end
	end
end