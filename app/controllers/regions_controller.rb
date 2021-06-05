class RegionsController < ApplicationController
  before_action :set_region, only: [:show, :edit, :update, :destroy]
  before_action :set_taxon, only: [:index, :show]

  # GET /regions
  # GET /regions.json

  def index
    @regions = @taxon.valid_regions.countries
  end


  # def show
  #   @taxon = @taxon.root
  # end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_region
    @region = Region.find(params[:id])
    @taxon = Taxon.find(params[:taxon_id])
  end


  def set_taxon
    @taxon = Taxon.find(params[:taxon_id])
  end


  # Never trust parameters from the scary internet, only allow the white list through.
  def region_params
    params.require(:region).permit(:name)
  end
end