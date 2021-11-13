class UsersController < ApplicationController
  before_action :require_user, only: %i[show edit update]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = 'Account registered!'
      redirect_to users_path
    else
      render action: :new
    end
  end

  def show
    @user = User.find(params[:id])
    @user ||= @current_user
  end

  def edit
    @user = User.find(params[:id])
    @user ||= @current_user
  end

  def update
    @user = @current_user # makes our views "cleaner" and more consistent
    if @user.update(user_params)
      redirect_to user_path, notice: 'Account updated!'
    else
      render action: :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.deactivate
      redirect_to users_path, notice: "#{@user} deactivated. They won't be able to log in."
    else
      render action: :view
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :email,
      :password,
      :username
    )
  end
end
