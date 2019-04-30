Raven.configure do |config|
  config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)

  if Rails.env.production?
    config.dsn = Rails.application.credentials.sentry[:dns]
  end
end
