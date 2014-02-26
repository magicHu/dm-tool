require 'redis'
require "redis/distributed"

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  @@redis_clients = []
  DmTool::Application.config.redis.split(',').each do |redis_server|
    host, port = redis_server.split(":")
    @@redis_clients << Redis.new(:host => host, :port => port)
  end

  @@pig_source_base_dir = DmTool::Application.config.pig_source_base_dir
  @@pig_log_dir = DmTool::Application.config.pig_log_dir

  protected
  def pig_source_base_dir
    @@pig_source_base_dir
  end

  def pig_log_dir
    @@pig_log_dir
  end

  def redis
    @@redis_clients[0]
  end

  def redis_clients
    @@redis_clients
  end

  def ad_campaign_keywords_key
    "adCampaignKeywords"
  end

  def ad_campaign_target_url
    "adCampaignTargetUrl"
  end

  def ad_campaign_keyword_channel
    "adCampaignKeywordChannel"
  end

  def ad_campaign_config_channel
    "adCampaignConfigChannel"
  end

  def rtt_ad_campaign_prefix
    "rtt:stat:"
  end

  def rtt_prefix
    "rtt:"
  end

  def current_task
    task_id = session[:task_id]
    if task_id
      PigTask.find(task_id)
    else
      task = PigTask.create
      session[:task_id] = task.id
      task
    end
  end
end
