class UserTaxonDataController < ApplicationController
  # before_action :set_user_species_datum, only: [:show, :edit, :update, :destroy]

  # GET /user_taxon_data/1
  # GET /user_taxon_data/1.json
  def show
    # puts Taxon.all.species.find(params[:id]).inspect
    @user_taxon_datum = UserTaxonDatum.find_or_create_by(user: current_user, taxon: Taxon.find(params[:id]))
  end

  # # GET /user_taxon_data
  # # GET /user_taxon_data.json
  # def index
  #   @user_taxon_data = UserTaxonDatum.all
  # end
  #
  # # GET /user_taxon_data/new
  # def new
  #   @user_taxon_datum = UserTaxonDatum.new
  # end
  #
  # # GET /user_taxon_data/1/edit
  # def edit
  # end
  #
  # # POST /user_taxon_data
  # # POST /user_taxon_data.json
  # def create
  #   @user_taxon_datum = UserTaxonDatum.new(user_species_datum_params)
  #
  #   respond_to do |format|
  #     if @user_taxon_datum.save
  #       format.html { redirect_to @user_taxon_datum, notice: 'User species datum was successfully created.' }
  #       format.json { render :show, status: :created, location: @user_taxon_datum }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @user_taxon_datum.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end
  #
  # # PATCH/PUT /user_taxon_data/1
  # # PATCH/PUT /user_taxon_data/1.json
  # def update
  #   respond_to do |format|
  #     if @user_taxon_datum.update(user_species_datum_params)
  #       format.html { redirect_to @user_taxon_datum, notice: 'User species datum was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @user_taxon_datum }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @user_taxon_datum.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end
  #
  # # DELETE /user_taxon_data/1
  # # DELETE /user_taxon_data/1.json
  # def destroy
  #   @user_taxon_datum.destroy
  #   respond_to do |format|
  #     format.html { redirect_to user_species_data_url, notice: 'User species datum was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_species_datum
      @user_taxon_datum = UserTaxonDatum.where(user: current_user, species: Species.find(params[:id]))[0]
    end
end
