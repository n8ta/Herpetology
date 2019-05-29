class RegionsController < ApplicationController
  before_action :set_region, only: [:show, :edit, :update, :destroy, :guess]
  before_action :authenticate_user!, except: [:index, :show, :guess]

  # GET /regions
  # GET /regions.json
  def index
    @regions = Region.all
  end

  def guess
    species = @region.species.includes(:photos).where.not(photos: {id: nil})
    specie_m = Species.find(session[:specie_id])
    correct = session[:index].to_s == params['guess_index'].to_s
    hash_and_specie = specie_hash(species)
    specie_data = {
        'sci_name': specie_m.sci_name.to_s,
        'common_name': specie_m.common_names[0].name.to_s,
        'index_was': session[:index].to_s,
        'next_options': hash_and_specie[0],
        'next_image_path': hash_and_specie[1].photos[rand(hash_and_specie[1].photos.length)].image_path.url,
        'correct': correct
    }
    render :json => specie_data
  end

  # GET /regions/1
  # GET /regions/1.json
  def show
    @species = @region.species.includes(:photos).where.not(photos: {id: nil})
    options = specie_hash(@species)
    correct_specie = options[1]
    @photo = correct_specie.photos[rand(correct_specie.photos.length)]
    @options = options[0]
  end

  def specie_hash(species)
    len = species.length
    correct_specie = species[rand(len)]
    picked = [correct_specie]
    hash_data = []
    while picked.length != 6
        trial_specie = species[rand(len)]
        unless picked.include?(trial_specie)
          picked.push(trial_specie)
          hash_data.push({sci_name: trial_specie.sci_name,
                                   common_name: trial_specie.common_names.any? ? trial_specie.common_names[0].name : ' '})
        end
    end
    index = rand(4)
    hash_data.insert(index, {sci_name: correct_specie.sci_name,
                            common_name: correct_specie.common_names.any? ? correct_specie.common_names[0].name : ' '})
    session[:index] = index
    session[:specie_id] = correct_specie.id
    return [hash_data,correct_specie] # hash, Species model
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
