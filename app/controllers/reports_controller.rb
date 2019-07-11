class ReportsController < ApplicationController
  before_action :contributor_only, only: [:edit, :update, :index, :destroy, :approve, :reject]
  before_action :set_report, only: [:show, :edit, :update, :destroy, :approve, :reject]

  # POST /reports/1/approve
  def approve
    puts "report:"
    puts @report.inspect
    # begin
    @report.approve(current_user) # Method on teh sub classes
    @report.handled = true # Action was taken by mod
    @report.approved = true # User was correct in their suggestion
    @report.handled_by = current_user
    @report.save!
    return render :json => {msg: 'Approved'}
    # rescue => e
    #   @report.handled = false
    #   @report.handled_by = nil
    #   puts e.inspect
    #   return render :json => {msg: "Failed"}, :status => :bad_request
    # end
  end

  # POST /reports/1/reject
  def reject
    @report.handled = true # Action was taken by mod
    @report.approved = false # User was incorrect
    @report.save!
    render :json => {msg: 'Rejected'}
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
    type = params[:type] # dead_herp_report, bad_id_report, venom_report, no_herp_report
    case type
    when "DeadHerpReport"
      @report = DeadHerpReport.new(dead_herp_params)
    when "BadIdReport"
      begin
      bdp = bad_id_params
      rescue => e
        x= 10
      end
      @report = BadIdReport.new(bdp)
    when "VenomReport"
      @report = VenomReport.new(venom_params)
      puts "Created venom report"
      puts venom_params.inspect
      puts @report.inspect
    when "NoHerpReport"
      @report = NoHerpReport.new(no_herp_params)
    end

    puts "type: "
    puts type.inspect

    @report.created_by = current_user if current_user
    respond_to do |format|
      if @report.save
        puts "Saved report"
        puts @report.inspect
        format.json {render json: {msg: 'Created report'}, status: :created}
      else
        format.json {render json: @report.errors, status: :unprocessable_entity}
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_report
    case params[:report_type]
    when "DeadHerpReport"
      @report = DeadHerpReport.find(params[:id])
    when "BadIdReport"
      @report = BadIdReport.find(params[:id])
    when "VenomReport"
      @report = VenomReport.find(params[:id])
    when "NoHerpReport"
      @report = NoHerpReport.find(params[:id])
    end
  end


  def dead_herp_params
    params.require(:photo_id)
    a = Hash.new
    a[:photo_id] = params[:photo_id]
    return a
  end

  def bad_id_params
    bad_id_params = {:taxon_id => params[:taxon_id], :photo_id => params[:photo_id]}
    return bad_id_params
  end

  def venom_params
    venom_p = {:taxon_id => Photo.find(params[:photo_id]).taxon.id, :venomous => params[:venomous]}
    puts "venom_p:"
    puts venom_p
    return venom_p
  end

  def no_herp_params
    params.require(:photo_id)
    a = Hash.new
    a[:photo_id] = params[:photo_id]
    return a

  end

end
