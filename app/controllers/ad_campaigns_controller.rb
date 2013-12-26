class AdCampaignsController < ApplicationController
  
  after_filter :notify_rtt, only: [:create, :destroy]

  def index
    @ad_campaign_keywords = redis.hgetall(ad_campaign_keywords_key)

    @ad_campaign_match_count = {}
    @ad_campaign_keywords.each do |ad_campaign_id, keywords|
      @ad_campaign_match_count[ad_campaign_id] = multiple_redis.zcard(rtt_ad_campaign_prefix + ad_campaign_id)
    end
  end

  def destroy
    ad_campaign_id = params[:id]
    redis.hdel(ad_campaign_keywords_key, ad_campaign_id)

    redirect_to :action => :index
  end

  def create
    ad_campaign_id = params[:id]
    keywords = params[:keywords]
    redis.hset(ad_campaign_keywords_key, ad_campaign_id, keywords)

    redirect_to :action => :index
  end

  private
  def notify_rtt
    redis.publish(adCampaignKeywordChannel, "reload")
  end
end
