DEV = Rails.env == 'development'
TEST = Rails.env == 'test'
PROD = Rails.env == 'production'
if DEV || TEST
  BASEURL = 'http://motor-car-export.dev/'
else
  BASEURL = 'http://motor-car-export.herokuapp.com/'
end