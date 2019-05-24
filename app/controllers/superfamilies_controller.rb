class SuperfamiliesController < ApplicationController
  before_action :set_superfamily, only: [:show, :edit, :update, :destroy]

  # GET /superfamilies
  # GET /superfamilies.json
  def index
    @superfamilies = Superfamily.all
  end

  # GET /superfamilies/1
  # GET /superfamilies/1.json
  def show
  end

  # GET /superfamilies/new
  def new
    @superfamily = Superfamily.new
  end

  # GET /superfamilies/1/edit
  def edit
  end

  # POST /superfamilies
  # POST /superfamilies.json
  def create
    @superfamily = Superfamily.new(superfamily_params)

    respond_to do |format|
      if @superfamily.save
        format.html { redirect_to @superfamily, notice: 'Superfamily was successfully created.' }
        format.json { render :show, status: :created, location: @superfamily }
      else
        format.html { render :new }
        format.json { render json: @superfamily.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /superfamilies/1
  # PATCH/PUT /superfamilies/1.json
  def update
    respond_to do |format|
      if @superfamily.update(superfamily_params)
        format.html { redirect_to @superfamily, notice: 'Superfamily was successfully updated.' }
        format.json { render :show, status: :ok, location: @superfamily }
      else
        format.html { render :edit }
        format.json { render json: @superfamily.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /superfamilies/1
  # DELETE /superfamilies/1.json
  def destroy
    @superfamily.destroy
    respond_to do |format|
      format.html { redirect_to superfamilies_url, notice: 'Superfamily was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_superfamily
      @superfamily = Superfamily.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def superfamily_params
      params.require(:superfamily).permit(:name)
    end
end
