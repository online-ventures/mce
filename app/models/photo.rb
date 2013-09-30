require 'zip/zip'
class Photo < ActiveRecord::Base
	# populates deleted_at, and prevents deletion
	acts_as_paranoid
	attr_accessible :image, :vehicle_id, :vehicle_string, :vehicles_photo_id, :deleted_at, :featured?
	belongs_to :vehicle, touch: true

	has_attached_file :image
	validates_attachment :image, presence: {message: 'must be chosen before saving'}
	#validates_attachment :image, content_type: {content_type: [/^image\/(png|gif|jpe?g)$/, /^application\/.*zip.*$/]}
	validates_is_photo_or_zip :image
	before_post_process :image?
	before_create :set_vehicles_photo_id
	before_save :detect_zipped_file
	after_save :remove_zipped_file

	scope :active, where(deleted_at: nil)
	scope :inactive, where('deleted_at IS NOT NULL')

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

	def activate
		update_attribute :deleted_at, nil
	end

	def rename_files(old_name, bucket)
		# Generate what the file name was
		file_name = "#{old_name}_#{vehicles_photo_id}#{File.extname(image.path)}"
		if PROD
			# Rename the old to the new on S3
			object = AWS::S3::S3Object.new(bucket, file_name)
			object.move_to image.path[1..-1], acl: :public_read
		else
			# Rename the old to the new locally
			path = File.join(Rails.root, 'public', 'uploads/') << file_name
			FileUtils.move(path, image.path)
		end
		save
	  end

	private
	def set_vehicles_photo_id
		self.vehicles_photo_id = (vehicle.photos.maximum(:vehicles_photo_id)|| 0) + 1
		self.vehicle_string = "#{vehicle.to_s '_'}_original"
	end

	def detect_zipped_file
		if zip?
			@vehicle ||= vehicle
			Zip::ZipFile.open(image.queued_for_write[:original].path) do |zipfile|
				zipfile.each do |entry|
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
