class PigTask < ActiveRecord::Base 

  has_many :task_jobs, :order => "position", dependent: :destroy
  has_many :jobs, through: :task_jobs
  has_many :params, through: :jobs

  BASH_PATH = "/opt/dm"

  def generate_command(params)
    command = ""

    if jobs.size >= 2
      command << %(<
        #!/bin/bash
        export JAVA_HOME=/opt/jdk1.6.0_31
        export PATH=$JAVA_HOME/bin:$PATH
        export CLASSPATH=.:$JAVA_HOME/lib/tools.jar:$JAVA_HOME/lib/dt.jar:$CLASSPATH
        export HADOOP_MAPRED_HOME=/usr/lib/hadoop-mapreduce

      >)
    end

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
      command << " -p #{param.name}=#{base_path}/#{param_value} "
    end
    command << " #{BASH_PATH}/#{job.path} "

    command
  end
end
