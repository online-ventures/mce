Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  env = Rails.env.to_sym
  conf = Rails.application.credentials.redis[env]

  redis = {
    url: "redis://#{conf[:host]}:#{conf[:port]}",
    namespace: conf[:namespace]
  }
  redis[:password] = conf[:password] if conf[:password]
  config.cache_store = :redis_cache_store, *redis

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  # Compress JavaScripts and CSS
  config.assets.js_compressor = :uglifier

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  config.eager_load = true

  # Generate digests for assets URLs
  config.assets.digest = true

  # Defaults to nil and saved in location specified by config.assets.prefix
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Prepend all log lines with the following tags
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js.coffee, application.css, and all non-JS/CSS are already added)
  # config.assets.precompile += %w( search.js )

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Silence Deprecation Notices by Heroku (Not A Real Problem)
  #config.active_support.deprecation = :silence

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  # config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Store uploaded files on the local file system (see config/storage.yml for options)
  config.active_storage.service = :amazon

  # Smtp settings
  config.action_mailer.smtp_settings = {
    address: 'smtp.mandrillapp.com',
    port: 587,
    domain: 'motorcarexport.com',
    user_name: ENV['MANDRILL_USERNAME'],
    password: ENV['MANDRILL_PASSWORD']
  }
  config.action_mailer.default_url_options = {
    host: 'motorcarexport.com'
  }

  # Raven for sentry
  config.dsn = Rails.application.credentials.sentry[:dns]

  # Logger configuration
  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger                  = ActiveSupport::Logger.new(STDOUT)
    logger.formatter        = config.log_formatter
    config.logger           = ActiveSupport::TaggedLogging.new(logger)
    config.colorize_logging = false
  end
end
