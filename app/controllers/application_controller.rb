class ApplicationController < ActionController::Base

  before_action :create_username
  before_action :set_raven_context


  def create_username
    controller = request.controller_class.to_s
    if ((controller == "SocialController") || (controller == "Users::RegistrationsController"))
      puts "SKIPPING"
    elsif (current_user && current_user.username.nil?)
      puts "REDIRECTING TO SET USERNAME"
      return render 'social/set_username'
    end
  end

  def require_login
    if !current_user
      flash[:notice] = "You must be logged in for that"
      redirect_to '/users/sign_up'
      @rendered = true
    end
  end

  def admin_only
    require_login
    return if @rendered
    if !current_user.admin?
      flash[:alert] = "Sorry that's an admin only action"
      redirect_back fallback_location: '/'
    end
  end

  def contributor_only
    require_login
    return if @rendered
    if current_user.user_class != "admin" and current_user.user_class != "contributor"
      flash[:alert] = "You must be a contributor to do that. To become a contributor contact Nate Tracy-Amoroso. See the github page."
      redirect_back fallback_location: '/'
    end
  end

  private

  def set_raven_context
    if current_user
      Raven.user_context(id: current_user.id,
                       email: current_user.email,
                       user_class: current_user.user_class)
    end
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end


end
