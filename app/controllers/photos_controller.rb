class PhotosController < ApplicationController
  before_action :contributor_only
  before_action :set_photo

  def edit
  end

  def destroy
    @photo.destroy
    flash[:notice] = "Photo deleted"
    redirect_to reports_url
  end

  def show
  end


  def set_photo
    @photo = Photo.find params[:id]
  end

end
