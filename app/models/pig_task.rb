class PigTask < ActiveRecord::Base 

  has_many :task_jobs, :order => "position", dependent: :destroy
  has_many :jobs, through: :task_jobs
  has_many :params, through: :jobs

  default_scope order('created_at DESC')

  PIG_JAR_BASE_DIR = DmTool::Application.config.pig_jar_base_dir
  PIG_SHELL_DIR = DmTool::Application.config.pig_shell_dir
  PIG_LOG_DIR = DmTool::Application.config.pig_log_dir
  PIG_SOURDE_BASE_DIR = DmTool::Application.config.pig_source_base_dir

  def pig_shell_path
    FileUtils.mkdir_p(PIG_SHELL_DIR) unless File.directory?(PIG_SHELL_DIR)
    "#{PIG_SHELL_DIR}/#{self.id}.sh"
  end

  def pig_log_path
    FileUtils.mkdir_p(PIG_LOG_DIR) unless File.directory?(PIG_LOG_DIR)
    "#{PIG_LOG_DIR}/#{self.id}.log"
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
    command = %(#!/bin/bash
export JAVA_HOME=/opt/jdk1.6.0_31
export PATH=$JAVA_HOME/bin:$PATH
export CLASSPATH=.:$JAVA_HOME/lib/tools.jar:$JAVA_HOME/lib/dt.jar:$CLASSPATH
export HADOOP_MAPRED_HOME=/usr/lib/hadoop-mapreduce
)

    jobs.each do |job|
      command << "\r\n" << generate_job_command(job, params)
    end
    command
  end

  def generate_job_command(job, params)
    command = "# #{job.desc}\r\n"
    command << "pig -Dpig.additional.jars=#{PIG_JAR_BASE_DIR}/fastjson-1.1.24.jar:#{PIG_JAR_BASE_DIR}/pig-ext-1.0-SNAPSHOT.jar:#{PIG_JAR_BASE_DIR}/piggybank.jar"
    command << ":#{PIG_JAR_BASE_DIR}/lib/*" if job.hbase?

    job.params.each do |param|
      param_value = params[param.name]

      if param.is_path?
        command << " -p #{param.name}=#{base_path}/#{param_value}"
      else
        command << " -p #{param.name}=#{param_value}"
      end
    end
    command << " #{PIG_SOURDE_BASE_DIR}/#{job.path}" << "\r\n"
    command
  end
end
