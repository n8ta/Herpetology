class SocialController < ApplicationController
  def set_username
  end

  def post_set_username
    username = params[:user][:username]
    current_user.username = username
    current_user.save!
    flash[:notice] = "Username set to " + username
    if session[:return_url]
      redirect_to session[:return_url]
    else
      redirect_to '/'
    end
  end


  def set_return_url
    url = params[:url]
    session[:return_url] = url
    render :json => ("Set to: "+url).to_json
  end
end