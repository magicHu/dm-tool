require 'redis'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  host, port = DmTool::Application.config.redis.split(":")
  @@redis = Redis.new(:host => host, :port => port)


  protected
  def redis
    @@redis
  end

  def ad_campaign_keywords_key
    "adCampaignKeywords"
  end

  def adCampaignKeywordChannel
    "adCampaignKeywordChannel"
  end

  def rtt_ad_campaign_prefix
    "rtt:stat:"
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
