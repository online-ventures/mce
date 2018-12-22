MotorCarExport::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Email Settings
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default_url_options = {
    host: "mce.dev"
  }
  config.action_mailer.smtp_settings = {
    address: 'localhost',
    port: 1025
  }

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Do not compress assets
  config.assets.js_compressor = nil

  # Expands the lines which load the assets
  config.assets.debug = true

  # Silences asset lines in logs
  config.quiet_assets = true

  ActionController::Base.asset_host = Proc.new { |source|
    if source =~ /.*\.(jp[e]?g|gif|png|ico)/
      'http://images.motor-car-export.dev'
    else
      'http://assets.motor-car-export.dev'
    end
  }
end
