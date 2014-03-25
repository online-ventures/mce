location = '/:vehicle_id/:vehicle_photo_id.:extension'

url = REMOTE ? ':s3_domain_url' : '/uploads' + location
Paperclip::Attachment.default_options[:url] = url

path = REMOTE ? '' : ':rails_root/public/uploads'
Paperclip::Attachment.default_options[:path] = path + location

Paperclip::Attachment.default_options[:default_style] = :original

#http://viget.com/extend/paperclip-custom-interpolation
Paperclip.interpolates(:vehicle_id)    {|a,s| a.instance.vehicle_id }
Paperclip.interpolates(:vehicle_photo_id)       {|a,s| a.instance.vehicles_photo_id }
