class ApplicationController < ActionController::Base

  before_action :create_username

  def create_username
    path = request.path
    if (path[0..24] == "/users/username_available")
    elsif (current_user && current_user.username.nil?)
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


end
