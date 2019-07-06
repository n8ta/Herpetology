class ReportsController < ApplicationController
  before_action :contributor_only, only: [:edit, :update, :index, :destroy, :approve]
  before_action :set_report, only: [:show, :edit, :update, :destroy, :approve]


  # POST /reports/1/approve
  def approve

  end

  # GET /reports
  # GET /reports.json
  def index
    @reports = Report.all.pending
  end

  # GET /reports/1
  # GET /reports/1.json
  def show
  end

  # GET /reports/new
  def new
    @photo = Photo.find(params[:photo_id])
    @taxon = @photo.taxon
    @venomous = "unknown"
    @venomous = "venomous" if @taxon.venomous == true
    @venomous = "nonvenomous" if @taxon.venomous == false
    @report = Report.new
  end

  # GET /reports/1/edit
  def edit
  end

  # POST /reports
  # POST /reports.json
  def create
    parsed = report_params
    parsed[:taxon] = Taxon.find_by(name: parsed[:taxon])
    parsed[:no_herp] = true if parsed[:no_herp]
    session[:return_url] = params[:return_url]
    @report = Report.new(parsed)
    @report.created_by = current_user if current_user
    respond_to do |format|
      if @report.save
        format.html { redirect_to params[:return_url], notice: 'Report was created. Thanks!' }
        format.json { render :show, status: :created, location: @report }
      else
        format.html { render :new }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reports/1
  # PATCH/PUT /reports/1.json
  def update
    respond_to do |format|
      if @report.update(report_params)
        format.html { redirect_to @report, notice: 'Report was successfully updated.' }
        format.json { render :show, status: :ok, location: @report }
      else
        format.html { render :edit }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reports/1
  # DELETE /reports/1.json
  def destroy
    @report.destroy
    respond_to do |format|
      format.html { redirect_to reports_url, notice: 'Report was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_report
      @report = Report.find(params[:id])
    end

  # Never trust parameters from the scary internet, only allow the white list through.
    def report_params
      params.require(:report).permit(:type, :taxon_id, :taxon, :photo_id, :venomous, :no_herp)
    end
end
