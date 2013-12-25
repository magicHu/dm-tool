class AdCampaignsController < ApplicationController
  
  after_filter :notify_rtt, only: [:create, :destroy]

  def index
    @ad_campaign_keywords = redis.hgetall(ad_campaign_keywords_key)
  end

  def destroy
    ad_campaign_id = params[:id]
    redis.hdel(ad_campaign_keywords_key, ad_campaign_id)

    redirect_to :action => :index
  end

  def create
    binding.pry
    ad_campaign_id = params[:id]
    keywords = params[:keywords]
    redis.hset(ad_campaign_keywords_key, ad_campaign_id, keywords)

    redirect_to :action => :index
  end
  

  private
  def ad_campaign_keywords_key
    "adCampaignKeywords"
  end

  def adCampaignKeywordChannel
    "adCampaignKeywordChannel"
  end

  def notify_rtt
    redis.publish(adCampaignKeywordChannel, "reload")
  end
end
