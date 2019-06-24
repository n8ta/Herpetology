class RegionsController < ApplicationController
  before_action :set_region, only: [:show, :edit, :update, :destroy]

  # GET /regions
  # GET /regions.json
  def index
    @regions = Region.countries.all.select { |t1| t1.taxons.species.select{ |sp| sp.root_taxon_id = @taxon.id && sp.photos.any? } .count > 5 }
  end

  def show
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_region
    @region = Region.find(params[:id])
    @taxon = Taxon.find(params[:taxon_id])
  end


  # Never trust parameters from the scary internet, only allow the white list through.
  def region_params
    params.require(:region).permit(:name)
  end
end