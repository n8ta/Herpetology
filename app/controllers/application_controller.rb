class ApplicationController < ActionController::Base

  def require_login
    if !current_user
      flash[:notice] = "You must be logged in to submit a tip"
      redirect_to '/users/sign_up'
    end
  end

  def admin_only
    require_login
    if !current_user.admin?
      flash[:alert] = "Sorry that's an admin only action"
      redirect_back fallback_location: '/'
    end
  end

  def contributor_only
    require_login
    if current_user.admin_or_contributor?
      flash[:alert] = "You must be a contributor to do that. To become a contributor contact Nate Tracy-Amoroso. See the github page."
      redirect_back fallback_location: '/'
    end
  end


end
