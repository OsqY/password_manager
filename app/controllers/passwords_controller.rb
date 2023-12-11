class PasswordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_password, except: [:index, :new, :create]
  before_action :require_editable_permissions, only: [:edit, :update]
  before_action :require_deletable_permissions, only: [:destroy]


  def index
    @passwords = current_user.passwords
  end

  def show
  end

  def new
    @password = Password.new
  end

  def create
    # @password = current_user.passwords.create(password_params)
    # if @password.persisted?
    @password = Password.new(password_params)
    @password.user_passwords.new(user: current_user, role: :owner)
    if @password.save
      redirect_to @password
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @password = current_user.passwords.find(params[:id])
  end

  def update
    @password = current_user.passwords.find(params[:id])
    if @password.update(password_params)
      redirect_to @password
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @password = current_user.passwords.find(params[:id])
    @password.destroy
    redirect_to root_path
  end

  private

  def password_params
    params.require(:password).permit(:username, :password, :url)
  end

  def set_password
      @password = current_user.passwords.find(params[:id])
  end

  def require_editable_permissions
    redirect_to @password unless current_user_password.editable?
  end

  def require_deletable_permissions
    redirect_to @password unless current_user_password.deletable?
  end

end