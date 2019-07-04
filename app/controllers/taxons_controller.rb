class TaxonsController < ApplicationController
  before_action :set_taxon, only: [:show, :edit, :update, :destroy]

  def search
    name = params[:name]
    @taxons = Taxon.all.where("lower(name) LIKE ?",'%'+name.downcase+'%').limit 100
    common_names = CommonName.all.where("lower(name) LIKE ?",'%'+name.downcase+'%').limit 100
    common_names = common_names.map {|cn| cn.taxon }
    @taxons = @taxons + common_names
    @taxons.uniq


    render 'index', formats: [:json]
  end

  def show
    @taxons = @taxon.taxons
  end

  def index
    @taxons = Taxon.where(taxon: nil)
  end

  # def edit
  # end
  #
  # def update
  #   @taxon.update(taxon_params)
  #   redirect_to taxon_path(@taxon)
  # end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_taxon
    @taxon = Taxon.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def taxon_params
    params.require(:taxon).permit(:name, :photo)
  end
end