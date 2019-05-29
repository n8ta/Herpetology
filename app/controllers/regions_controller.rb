class RegionsController < ApplicationController
  before_action :set_region, only: [:show, :edit, :update, :destroy, :guess]
  before_action :authenticate_user!, except: [:index, :show, :guess]

  # GET /regions
  # GET /regions.json
  def index
    @regions = Region.all
  end

  def guess
    specie_m = Species.find(session[:specie_id])
    specie_data = {
      'sci_name': specie_m.sci_name.to_s,
      'common_name': specie_m.common_names[0].name.to_s,
      'index_was': session[:index].to_s,
      }
    puts "SESSION[index]  "
    puts session[:index].inspect
    puts "params[guess_index]"
    puts params[:guess_index].inspect
    if session[:index].to_s == params['guess_index'].to_s
      puts "MATCHED"
      specie_data[:correct] = true
      render :json => specie_data
    else
      specie_data[:correct] = false
      render :json => specie_data
    end

  end

  # GET /regions/1
  # GET /regions/1.json
  def show
    @species = @region.species.includes(:photos).where.not(photos: {id: nil})
    @len = @species.length
    @specie = @species[rand(@len)]
    @photo = @specie.photos[rand(@specie.photos.length)]
    @options = [0, 1, 2, 3, 4].map {|num|
      specie = @species[rand(@len)]
      {
          sci_name: specie.sci_name,
          common_name: specie.common_names.any? ? specie.common_names[0].name : ' '
      }
    }
    index = rand(4)
    @options.insert(index,{sci_name: @specie.sci_name,
                             common_name: @specie.common_names.any? ? @specie.common_names[0].name : ' '})
    session[:index] = index
    session[:specie_id] = @specie.id
  end

  # GET /regions/new
  def new
    @region = Region.new
  end

  # GET /regions/1/edit
  def edit
  end

  # POST /regions
  # POST /regions.json
  def create
    @region = Region.new(region_params)

    respond_to do |format|
      if @region.save
        format.html {redirect_to @region, notice: 'Region was successfully created.'}
        format.json {render :show, status: :created, location: @region}
      else
        format.html {render :new}
        format.json {render json: @region.errors, status: :unprocessable_entity}
      end
    end
  end

  # PATCH/PUT /regions/1
  # PATCH/PUT /regions/1.json
  def update
    respond_to do |format|
      if @region.update(region_params)
        format.html {redirect_to @region, notice: 'Region was successfully updated.'}
        format.json {render :show, status: :ok, location: @region}
      else
        format.html {render :edit}
        format.json {render json: @region.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /regions/1
  # DELETE /regions/1.json
  def destroy
    @region.destroy
    respond_to do |format|
      format.html {redirect_to regions_url, notice: 'Region was successfully destroyed.'}
      format.json {head :no_content}
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_region
    @region = Region.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def region_params
    params.require(:region).permit(:name)
  end
end
