# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  def username_available
    username = JSON.parse(Base64.decode64(params[:username]))
    if User.find_by(username: username).nil?
      render :json => {valid: true}
    else
      render :json => {valid: false}
    end
  end

  def email_available
    email = JSON.parse(Base64.decode64(params[:email]))
    if User.find_by(email: email).nil?
      render :json => {valid: true}
    else
      render :json => {valid: false}
    end

  end


  # GET /resource/sign_up
  def new
    super
  end

  # POST /resource
  def create
    session[:return_url] = params[:return_url]
    super
  end

  # GET /resource/edit
  def edit
    super
  end

  # PUT /resource
  def update
    super
  end

  # DELETE /resource
  def destroy
    super
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  def cancel
    super
  end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    if session[:return_url] != nil
      flash[:notice] = "You have signed up! There is no confirmation email"
      return session[:return_url]
    else
      super(resource)
    end
  end

  # The path used after sign up for inactive accounts.
  def after_inactive_sign_up_path_for(resource)
    super(resource)
  end
end
