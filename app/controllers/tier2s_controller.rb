class Tier2sController < ApplicationController
  before_action :set_tier2, only: [:show, :edit, :update, :destroy]

  # GET /tier2s
  # GET /tier2s.json
  def index
    @tier2s = Tier2.all
  end

  # GET /tier2s/1
  # GET /tier2s/1.json
  def show
  end

  # GET /tier2s/new
  def new
    @tier2 = Tier2.new
  end

  # GET /tier2s/1/edit
  def edit
  end

  # POST /tier2s
  # POST /tier2s.json
  def create
    @tier2 = Tier2.new(tier2_params)

    respond_to do |format|
      if @tier2.save
        format.html { redirect_to @tier2, notice: 'Tier2 was successfully created.' }
        format.json { render :show, status: :created, location: @tier2 }
      else
        format.html { render :new }
        format.json { render json: @tier2.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tier2s/1
  # PATCH/PUT /tier2s/1.json
  def update
    respond_to do |format|
      if @tier2.update(tier2_params)
        format.html { redirect_to @tier2, notice: 'Tier2 was successfully updated.' }
        format.json { render :show, status: :ok, location: @tier2 }
      else
        format.html { render :edit }
        format.json { render json: @tier2.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tier2s/1
  # DELETE /tier2s/1.json
  def destroy
    @tier2.destroy
    respond_to do |format|
      format.html { redirect_to tier2s_url, notice: 'Tier2 was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tier2
      @tier2 = Tier2.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tier2_params
      params.require(:tier2).permit(:name, :tier1_id)
    end
end
