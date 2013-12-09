class PigTask < ActiveRecord::Base
  BASH_PATH = "/opt/dm"

  def self.create_task(job, params = {})
    command = "pig -Dpig.additional.jars=#{BASH_PATH}/fastjson-1.1.24.jar:#{BASH_PATH}/pig-ext-1.0-SNAPSHOT.jar:#{BASH_PATH}/piggybank.jar"
    command << ":#{BASH_PATH}/lib/*" if job.hbase?

    hadoop_base_path = params["hadoop_base_path"]
    job.params.each do |param|
      param_value = params[param.name]

      command << " -p #{param.name}=#{hadoop_base_path}/#{param_value} "
      command << " #{BASH_PATH}/#{job.path} "
    end

    PigTask.new(command: command)
  end
end
