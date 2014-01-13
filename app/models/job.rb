class Job < ActiveRecord::Base

  has_and_belongs_to_many :params 
  has_many :task_jobs
  has_many :tasks, class_name: 'PigTask', through: :task_jobs

  validates :name, :desc, :path, presence: true

  @@pig_source_base_dir = DmTool::Application.config.pig_source_base_dir

  def script_path
    "#{@@pig_source_base_dir}/#{path}"
  end
end
