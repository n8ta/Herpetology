class Tier3sController < ApplicationController
  before_action :set_tier3, only: [:show, :edit, :update, :destroy]

  # GET /tier3s
  # GET /tier3s.json
  def index
    @tier3s = Tier3.all
  end

  # GET /tier3s/1
  # GET /tier3s/1.json
  def show
  end

  # GET /tier3s/new
  def new
    @tier3 = Tier3.new
  end

  # GET /tier3s/1/edit
  def edit
  end

  # POST /tier3s
  # POST /tier3s.json
  def create
    @tier3 = Tier3.new(tier3_params)

    respond_to do |format|
      if @tier3.save
        format.html { redirect_to @tier3, notice: 'Tier3 was successfully created.' }
        format.json { render :show, status: :created, location: @tier3 }
      else
        format.html { render :new }
        format.json { render json: @tier3.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tier3s/1
  # PATCH/PUT /tier3s/1.json
  def update
    respond_to do |format|
      if @tier3.update(tier3_params)
        format.html { redirect_to @tier3, notice: 'Tier3 was successfully updated.' }
        format.json { render :show, status: :ok, location: @tier3 }
      else
        format.html { render :edit }
        format.json { render json: @tier3.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tier3s/1
  # DELETE /tier3s/1.json
  def destroy
    @tier3.destroy
    respond_to do |format|
      format.html { redirect_to tier3s_url, notice: 'Tier3 was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tier3
      @tier3 = Tier3.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tier3_params
      params.require(:tier3).permit(:name, :tier2_id)
    end
end
