class AdCampaignsController < ApplicationController
  
  after_filter :notify_rtt_keywords, only: [:create, :destroy]

  def index
    @ad_campaign_keywords = redis.hgetall(ad_campaign_keywords_key) || {}
    @ad_campaign_target_url = redis.hgetall(ad_campaign_target_url) || {}

    @ad_campaign_match_count = {}
    (@ad_campaign_keywords.keys + @ad_campaign_target_url.keys).each do |ad_campaign_id|
      key = rtt_ad_campaign_prefix + ad_campaign_id
      redis_clients.each do |redis_client|
        ad_campaign_match_count = @ad_campaign_match_count[ad_campaign_id]
        unless ad_campaign_match_count && ad_campaign_match_count > 0
          @ad_campaign_match_count[ad_campaign_id] = redis_client.zcard(key)
        end
      end
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
  def notify_rtt_keywords
    #redis.publish(adCampaignKeywordChannel, "reload")
    redis.publish(ad_campaign_config_channel, "keywords")
  end

  def notify_rtt_target_url
    redis.publish(ad_campaign_config_channel, "retargetUrl")
  end
end
