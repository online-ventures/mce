ActiveRecord::Base.class_eval do
	def self.validates_is_photo_or_zip(*attr_names)
		validates_each(attr_names) do |record, attr_name, value|
			if record.respond_to? attr_name
				attachment = record.send attr_name
				if attachment.is_a? Paperclip::Attachment
					unless record.image? or record.zip?
						record.errors[:base] << "The uploaded file doesn't appear to be either a photo or a zip."
					end
				end
			end
		end
	end
end
