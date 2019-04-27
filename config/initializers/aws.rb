# AWS credentials
aws = Rails.application.credentials.aws
creds = Aws::Credentials.new(
  aws[:spaces_key],
  aws[:spaces_secret]
)

# Set AWS defaults
Aws.config.update({
  region:       aws[:region],
  endpoint:     aws[:endpoint],
  credentials:  creds
})
