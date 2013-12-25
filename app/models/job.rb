class Job < ActiveRecord::Base

  has_and_belongs_to_many :params 
  has_many :task_jobs
  has_many :tasks, class_name: 'PigTask', through: :task_jobs

  
end
