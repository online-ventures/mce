class UserSessionsController < ApplicationController
  before_action :require_no_user, only: %i[new create]
  before_action :require_user, only: :destroy

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(user_session_params.to_h)
    if @user_session.save
      flash[:notice] = 'Login successful!'
      redirect_to session[:return_to] || '/members'
    else
      render action: :new, as: 'login'
    end
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = 'Logout successful!'
    redirect_to root_url
  end

  private

  def user_session_params
    params.require(:user_session).permit(:login, :email, :username, :password)
  end
end
