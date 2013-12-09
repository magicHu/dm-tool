class PigTasksController < ApplicationController
  before_action :set_pig_task, only: [:show, :edit, :update, :destroy]

  # GET /pig_tasks
  # GET /pig_tasks.json
  def index
    @pig_tasks = PigTask.all
  end

  # GET /pig_tasks/1
  # GET /pig_tasks/1.json
  def show
  end

  # GET /pig_tasks/new
  def new
    @pig_task = PigTask.new
  end

  # GET /pig_tasks/1/edit
  def edit
  end

  # POST /pig_tasks
  # POST /pig_tasks.json
  def create
    @pig_task = PigTask.new(pig_task_params)

    respond_to do |format|
      if @pig_task.save
        format.html { redirect_to @pig_task, notice: 'Pig task was successfully created.' }
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
      params.require(:pig_task).permit(:command)
    end
end
