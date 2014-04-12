class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user_session, :current_user
  before_filter :begin_profiling, :current_user, :set_action_mailer_defaults, :mixpanel_settings
  after_filter :remember_subscriber

  def render *args
    before_render
    super
  end

  private

    def before_render
      if @subscriber and @subscriber.email =~ /motorcarexport\.com|csgronow@gmail\.com|webonlineventures\.com|wov\.io/
        Rails.configuration.mixpanel[:selected] = Rails.configuration.mixpanel[:sandbox]
      end
    end

    def mixpanel_settings
      #if params[:mps] and params[:subscriber].is_a? Array
        #params[:subscriber][:source] = params[:mps]
      #end
      # Remember the source
      if params[:mps]
        cookies[:mps] = params[:mps]
      end
      # Detect a subscriber from cookie
      if session[:mpsub]
        @subscriber = Subscriber.find_by_token session[:mpsub]
      end
    end

    def mixpanel
      tracker ||= Mixpanel::Tracker.new Rails.configuration.mixpanel[:selected]
    end

    def mixpanel_data(additional_data = {})
      data = @subscriber ? @subscriber.to_mixpanel_hash : {}
      if @vehicle
        data.merge! @vehicle.to_mixpanel_hash
      end
      if params[:mps]
        data.merge! source: params[:mps]
      elsif cookies[:mps]
        data.merge! source: cookies[:mps]
      end
      if additional_data
        data.merge! additional_data
      end
      data
    end

    def remember_subscriber
      if @subscriber
        session[:mpsub] = @subscriber.token
      end
    end

    def begin_profiling
      if params[:profiler] == 'true'
        Rack::MiniProfiler.authorize_request
      end
    end

    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end

    def require_user
      unless current_user
        store_location
        flash[:notice] = "You must be logged in to access this page"
        redirect_to '/login'
      end
    end

    def require_no_user
      if current_user
        store_location
        flash[:notice] = "You are already signed in"
        redirect_to root_url
        return false
      end
    end

    def store_location
      session[:return_to] = request.url
    end

    def set_action_mailer_defaults
      ActionMailer::Base.default_url_options[:host] = request.host_with_port
    end
end
