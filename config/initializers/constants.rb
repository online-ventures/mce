DEV = Rails.env == 'development'
TEST = Rails.env == 'test'
PROD = Rails.env == 'production'
STAGING = Rails.env == 'staging'
REMOTE = (PROD or STAGING)
