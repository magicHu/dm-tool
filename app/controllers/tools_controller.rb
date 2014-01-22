class ToolsController < ApplicationController
  def index
  end

  def download
    hdfs_path = params[:hdfs_path]
    local_path = params[:local_path]

    command = "hadoop fs -getmerge #{hdfs_path} #{local_path}"    
    system("#{command}", :out =>["#{pig_log_dir}/hdfs.log", 'w'])

    respond_to do |format|
      format.html { redirect_to action: 'index', notice: "download #{hdfs_path} to #{local_path} success." }
      format.json { head :no_content }
    end
  end
end
