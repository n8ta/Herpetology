# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  def settings
    opt_out_of_email = params[:opt_out_of_email]
    show_dead = params[:show_dead]

    current_user.opt_out_of_email = opt_out_of_email
    current_user.show_dead_photos = show_dead
    current_user.save

    render :json => {"opted_out_of_email": current_user.opt_out_of_email, "show_dead_photos": current_user.show_dead_photos}.to_json()
  end

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
