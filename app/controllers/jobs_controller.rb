class JobsController < ApplicationController

  before_action :set_job, only: [:show, :edit, :update, :destroy, :run, :add_to_task, :update_script]

  # GET /jobs
  # GET /jobs.json
  def index
    @jobs = Job.page(params[:page])
  end

  # GET /jobs/1
  # GET /jobs/1.json
  def show
    @script_contents = ""
    if File.exist?(@job.script_path)
      @script_contents = File.open(@job.script_path, 'rb') {|f| f.read}
    end
  end

  # GET /jobs/new
  def new
    @job = Job.new
    @all_params = Param.all
  end

  # GET /jobs/1/edit
  def edit
    @all_params = Param.all
  end

  # POST /jobs
  # POST /jobs.json
  def create
    @job = Job.new(job_params)

    param_ids = params[:job][:param_ids]
    if param_ids
      param_ids.each do |param_id|
        @job.params << Param.find(param_id) unless param_id.blank? || param_id.to_i == 0
      end
    end

    respond_to do |format|
      if @job.save
        format.html { redirect_to @job, notice: 'Job was successfully created.' }
        format.json { render action: 'show', status: :created, location: @job }
      else
        format.html { render action: 'new' }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /jobs/1
  # PATCH/PUT /jobs/1.json
  def update
    respond_to do |format|
      if @job.update(job_params)
        format.html { redirect_to @job, notice: 'Job was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jobs/1
  # DELETE /jobs/1.json
  def destroy
    @job.destroy
    respond_to do |format|
      format.html { redirect_to jobs_url }
      format.json { head :no_content }
    end
  end

  def update_script
    script = params[:script]

    File.open(@job.script_path, 'wb') do |file|
      file.write(script)
    end

    respond_to do |format|
      format.html { redirect_to @job, notice: 'Pig script was successfully updated.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job
      @job = Job.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def job_params
      params.require(:job).permit(:name, :desc, :path, :hbase, :param_ids)
    end
end
