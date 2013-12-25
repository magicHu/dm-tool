class TaskJobsController < ApplicationController
  before_action :set_task_job

  def up
    @task_job.move_higher
    
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  def down
    @task_job.move_lower

    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
  def set_task_job
    @task = PigTask.find(params[:pig_task_id])
    @task_job = TaskJob.find(params[:id])
  end
end