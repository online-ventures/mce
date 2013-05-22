location = '/:vehicle_id/:vehicle_year_:vehicle_make_:vehicle_model_:style_:count.:extension'

url = PROD ? ':s3_domain_url' : '/uploads' + location
Paperclip::Attachment.default_options[:url] = url

path = PROD ? '' : ':rails_root/public/uploads'
Paperclip::Attachment.default_options[:path] = path + location

#http://viget.com/extend/paperclip-custom-interpolation
Paperclip.interpolates(:vehicle_id)    {|a,s| a.instance.vehicle.id }
Paperclip.interpolates(:vehicle_year)  {|a,s| a.instance.vehicle.year }
Paperclip.interpolates(:vehicle_make)  {|a,s| a.instance.vehicle.make.name }
Paperclip.interpolates(:vehicle_model) {|a,s| a.instance.vehicle.model.name }
Paperclip.interpolates(:count)         {|a,s| a.instance.vehicle.photos.count }