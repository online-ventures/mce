require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MotorCarExport
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    # config.active_record.schema_format = :sql

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    # Add the fonts path
    config.assets.paths << Rails.root.join('app', 'assets', 'fonts')
    # And the vendor paths
    config.assets.paths << Rails.root.join('vendor', 'assets', 'javascripts')
    config.assets.paths << Rails.root.join('vendor', 'assets', 'stylesheets')
    config.assets.paths << Rails.root.join('vendor', 'assets', 'images')

    # Precompile additional assets
    config.assets.precompile += %w(vehicles/ebay.css)

    #initialize logger
    config.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))

    # Autoload core extensions
    config.autoload_paths += Dir[File.join(Rails.root, "lib", "core_ext", "**", "*.rb")].each {|l| require l }

    # Don't initialize just to compile assets
    config.assets.initialize_on_precompile = false

    # Don't include model name in json
    ActiveRecord::Base.include_root_in_json = false

    # Security improvements
    config.action_controller.forgery_protection_origin_check = true
    config.action_controller.per_form_csrf_tokens = true
  end
end
