class PigTask < ActiveRecord::Base 

  has_many :task_jobs, :order => "position", dependent: :destroy
  has_many :jobs, through: :task_jobs
  has_many :params, through: :jobs

  BASH_PATH = "/dm/dm"
  BASIC_PIG_SHELL_DIR = "tmp/pig"
  BASIC_PIG_LOG_DIR = "log/pig"
  PIG_SOURDE_BASE_PATH = DmTool::Application.config.pig_source_base_path

  def pig_shell_path
    FileUtils.mkdir_p(BASIC_PIG_SHELL_DIR) unless File.directory?(BASIC_PIG_SHELL_DIR)
    "#{BASIC_PIG_SHELL_DIR}/#{self.id}.sh"
  end

  def pig_log_path
    FileUtils.mkdir_p(BASIC_PIG_LOG_DIR) unless File.directory?(BASIC_PIG_LOG_DIR)
    "#{BASIC_PIG_LOG_DIR}/#{self.id}.log"
  end

  def self.create_by_jobs(job_ids)
    pig_task = PigTask.new()
    if job_ids
      if job_ids.kind_of?(Array)
        job_ids.each do |job_id|
          pig_task.task_jobs.build(:job => Job.find(job_id)) unless job_id.blank?
        end
      else
        pig_task.task_jobs.build(:job => Job.find(job_ids)) unless job_ids.blank?
      end
    end
    pig_task
  end

  def generate_command(params)
    command = %(
#!/bin/bash
export JAVA_HOME=/opt/jdk1.6.0_31
export PATH=$JAVA_HOME/bin:$PATH
export CLASSPATH=.:$JAVA_HOME/lib/tools.jar:$JAVA_HOME/lib/dt.jar:$CLASSPATH
export HADOOP_MAPRED_HOME=/usr/lib/hadoop-mapreduce

)

    jobs.each do |job|
      command << generate_job_command(job, params)
      command << "\n"
    end
    command
  end

  def generate_job_command(job, params)
    command = "pig -Dpig.additional.jars=#{BASH_PATH}/fastjson-1.1.24.jar:#{BASH_PATH}/pig-ext-1.0-SNAPSHOT.jar:#{BASH_PATH}/piggybank.jar"
    command << ":#{BASH_PATH}/lib/*" if job.hbase?

    job.params.each do |param|
      param_value = params[param.name]

      if param.is_path?
        command << " -p #{param.name}=#{base_path}/#{param_value}"
      else
        command << " -p #{param.name}=#{param_value}"
      end
    end
    command << " #{PIG_SOURDE_BASE_PATH}/#{job.path}"

    command
  end
end
