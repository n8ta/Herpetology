class UserSpeciesDataController < ApplicationController
  # before_action :set_user_species_datum, only: [:show, :edit, :update, :destroy]

  # GET /user_species_data/1
  # GET /user_species_data/1.json
  def show
    puts Species.find(params[:id]).inspect
    @user_species_datum = UserSpeciesDatum.find_or_create_by(user: current_user, species: Species.find(params[:id]))
  end

  # # GET /user_species_data
  # # GET /user_species_data.json
  # def index
  #   @user_species_data = UserSpeciesDatum.all
  # end
  #
  # # GET /user_species_data/new
  # def new
  #   @user_species_datum = UserSpeciesDatum.new
  # end
  #
  # # GET /user_species_data/1/edit
  # def edit
  # end
  #
  # # POST /user_species_data
  # # POST /user_species_data.json
  # def create
  #   @user_species_datum = UserSpeciesDatum.new(user_species_datum_params)
  #
  #   respond_to do |format|
  #     if @user_species_datum.save
  #       format.html { redirect_to @user_species_datum, notice: 'User species datum was successfully created.' }
  #       format.json { render :show, status: :created, location: @user_species_datum }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @user_species_datum.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end
  #
  # # PATCH/PUT /user_species_data/1
  # # PATCH/PUT /user_species_data/1.json
  # def update
  #   respond_to do |format|
  #     if @user_species_datum.update(user_species_datum_params)
  #       format.html { redirect_to @user_species_datum, notice: 'User species datum was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @user_species_datum }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @user_species_datum.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end
  #
  # # DELETE /user_species_data/1
  # # DELETE /user_species_data/1.json
  # def destroy
  #   @user_species_datum.destroy
  #   respond_to do |format|
  #     format.html { redirect_to user_species_data_url, notice: 'User species datum was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_species_datum
      @user_species_datum = UserSpeciesDatum.where(user: current_user, species: Species.find(params[:id]))[0]
    end
end
