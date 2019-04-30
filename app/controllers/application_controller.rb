class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user_session, :current_user
  before_action :begin_profiling, :current_user, :set_action_mailer_defaults
  after_action :remember_subscriber

  private

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
