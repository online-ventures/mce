location = '/:vehicle_id/:vehicle_:style_:count.:extension'

url = PROD ? ':s3_domain_url' : '/uploads' + location
Paperclip::Attachment.default_options[:url] = url

path = PROD ? '' : ':rails_root/public/uploads'
Paperclip::Attachment.default_options[:path] = path + location

Paperclip::Attachment.default_options[:default_style] = :original

#http://viget.com/extend/paperclip-custom-interpolation
Paperclip.interpolates(:vehicle_id)    {|a,s| a.instance.vehicle.id }
Paperclip.interpolates(:vehicle)       {|a,s| a.instance.vehicle.to_s('_') }
Paperclip.interpolates(:count)         {|a,s| a.instance.vehicles_photo_id }