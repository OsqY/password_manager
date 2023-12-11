class SharesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_password
  before_action :require_shareable_permissions

  def new
    @user_password = UserPassword.new
  end

  def create
    @user_password = @password.user_passwords.new(user_password_params)
    if @user_password.save
      redirect_to @password, notice: 'Password was successfully shared.'
    else
      @users = User.excluding(@password.users)
      render  :new, status: :unprocessable_entity
    end
  end

  def destroy
    @password.user_passwords.where(user_id: params[:id]).destroy_all
    redirect_to @password, notice: 'Password was successfully unshared.'
  end

  private

  def set_password
    @password = current_user.passwords.find(params[:password_id])
    @user_password = UserPassword.new
  end

  def user_password_params
    params.require(:user_password).permit(:user_id, :role)
  end

  def require_shareable_permissions
    redirect_to @password unless current_user_password.shareable?
  end

end