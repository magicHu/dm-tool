class AdCampaignsController < ApplicationController
  
  after_filter :notify_rtt, only: [:create, :destroy]

  def index
    @ad_campaign_keywords = redis.hgetall(ad_campaign_keywords_key) || {}
    @ad_campaign_target_url = redis.hgetall(ad_campaign_target_url_key) || {}

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
    target_type = params[:target_type]

    if is_keywords?(target_type)
      redis.hdel(ad_campaign_keywords_key, ad_campaign_id)
    elsif is_retargeturl?(target_type)
      redis.hdel(ad_campaign_target_url_key, ad_campaign_id)
    end

    redirect_to :action => :index
  end

  def create
    ad_campaign_id = params[:id]
    target_type = params[:target_type]

    if is_keywords?(target_type)
      keywords = params[:keywords]
      redis.hset(ad_campaign_keywords_key, ad_campaign_id, keywords)
    elsif is_retargeturl?(target_type)
      target_url = params[:target_url]
      redis.hset(ad_campaign_target_url_key, ad_campaign_id, target_url)
    end
    
    redirect_to :action => :index
  end

  private

  def is_keywords?(target_type)
    target_type == "1"
  end

  def is_retargeturl?(target_type)
    target_type == "2"
  end

  def notify_rtt
    #redis.publish(adCampaignKeywordChannel, "reload")
    redis.publish(ad_campaign_config_channel, "keywords")
    redis.publish(ad_campaign_config_channel, "retargetUrl")
  end

end
