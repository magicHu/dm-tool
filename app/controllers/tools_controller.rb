class ToolsController < ApplicationController
  def index
  end

  def download
    hdfs_path = params[:hdfs_path]
    local_path = params[:lcoal_path]

    command = %(#!/bin/bash
export JAVA_HOME=/opt/jdk1.6.0_31
export PATH=$JAVA_HOME/bin:$PATH
export CLASSPATH=.:$JAVA_HOME/lib/tools.jar:$JAVA_HOME/lib/dt.jar:$CLASSPATH
export HADOOP_MAPRED_HOME=/usr/lib/hadoop-mapreduce

)
    command = "hadoop fs -getmerge #{hdfs_path} #{local_path}"
    system("#{command}", :out =>["#{pig_log_dir}/hdfs.log", 'w'])

    respond_to do |format|
      format.html { redirect_to action: 'index', notice: "download #{hdfs_path} to #{local_path} success." }
      format.json { head :no_content }
    end
  end
end
