class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :next, :post_next]

  def index
    @groups = Group.all
  end

  def show
  end

  def next
    render json: get_next
  end

  def post_next
    puts params
    photo = Photo.find(params[:photo_id])
    render json: {
      specie: photo.taxon.to_hash,
      photo: get_next
    }
  end

  private

  def get_next
    species = @group.taxons.filter { |t| t.num_photos > 0 }
    specie = species[rand(species.size)]
    photos = specie.photos.where(dead: false)
    photo = photos[rand(photos.size)]
    {
      url: photo.image_path.url,
      id: photo.id
    }
  end

  def set_group
    @group = Group.find(1)
  end
end
