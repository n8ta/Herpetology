class Tier1sController < ApplicationController
  before_action :set_tier1, only: [:show, :edit, :update, :destroy]

  # GET /tier1s
  # GET /tier1s.json
  def index
    @tier1s = Tier1.all
  end

  # GET /tier1s/1
  # GET /tier1s/1.json
  def show
  end

  # GET /tier1s/new
  def new
    @tier1 = Tier1.new
  end

  # GET /tier1s/1/edit
  def edit
  end

  # POST /tier1s
  # POST /tier1s.json
  def create
    @tier1 = Tier1.new(tier1_params)

    respond_to do |format|
      if @tier1.save
        format.html { redirect_to @tier1, notice: 'Tier1 was successfully created.' }
        format.json { render :show, status: :created, location: @tier1 }
      else
        format.html { render :new }
        format.json { render json: @tier1.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tier1s/1
  # PATCH/PUT /tier1s/1.json
  def update
    respond_to do |format|
      if @tier1.update(tier1_params)
        format.html { redirect_to @tier1, notice: 'Tier1 was successfully updated.' }
        format.json { render :show, status: :ok, location: @tier1 }
      else
        format.html { render :edit }
        format.json { render json: @tier1.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tier1s/1
  # DELETE /tier1s/1.json
  def destroy
    @tier1.destroy
    respond_to do |format|
      format.html { redirect_to tier1s_url, notice: 'Tier1 was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tier1
      @tier1 = Tier1.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tier1_params
      params.require(:tier1).permit(:name)
    end
end
