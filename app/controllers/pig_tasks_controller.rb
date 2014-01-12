class PigTasksController < ApplicationController
  before_action :set_pig_task, only: [:show, :edit, :update, :destroy, :run, :update_command]

  # GET /pig_tasks
  # GET /pig_tasks.json
  def index
    @pig_tasks = PigTask.page(params[:page])
  end

  # GET /pig_tasks/1
  # GET /pig_tasks/1.json
  def show
  end

  # GET /pig_tasks/new
  def new
    @pig_task = PigTask.new
    @jobs = Job.all
  end

  # GET /pig_tasks/1/edit
  def edit
    @jobs = @pig_task.jobs
    @params = @pig_task.params.uniq { |param| param.id }
  end

  def run
    File.open(@pig_task.pig_shell_path, 'wb') do |file|
      file.write(@pig_task.command)
    end
    system("nohup bash #{@pig_task.pig_shell_path} > #{@pig_task.pig_log_path} &")

    respond_to do |format|
      format.html { redirect_to pig_tasks_path, notice: "#{@pig_task.name} task was started..." }
    end
  end

  # POST /pig_tasks
  # POST /pig_tasks.json
  def create
    @pig_task = PigTask.create_by_jobs(params[:pig_task][:job_ids])

    respond_to do |format|
      if @pig_task.save
        format.html { redirect_to edit_pig_task_path(@pig_task), notice: 'Pig task was successfully created.' }
        format.json { render action: 'show', status: :created, location: @pig_task }
      else
        format.html { render action: 'new' }
        format.json { render json: @pig_task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pig_tasks/1
  # PATCH/PUT /pig_tasks/1.json
  def update
    task_params = params['task_params']
    @pig_task.assign_attributes(pig_task_params)
    @pig_task.command = @pig_task.generate_command(task_params)

    respond_to do |format|
      if @pig_task.update(pig_task_params)
        format.html { redirect_to @pig_task, notice: 'Pig task was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @pig_task.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_command
    respond_to do |format|
      if @pig_task.update(pig_task_params)
        format.html { redirect_to @pig_task, notice: 'Pig task command was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'show' }
        format.json { render json: @pig_task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pig_tasks/1
  # DELETE /pig_tasks/1.json
  def destroy
    @pig_task.destroy
    respond_to do |format|
      format.html { redirect_to pig_tasks_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pig_task
      @pig_task = PigTask.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pig_task_params
      params.require(:pig_task).permit(:name, :command, :base_path, :job_ids)
    end
end
