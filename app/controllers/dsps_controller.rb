class DspsController < ApplicationController

  def index
    
  end

  def search_match_ad_campaign
    cookie = params[:cookie]

    redis_clients.each do |redis_client|
      unless @ad_campaign_ids && @ad_campaign_ids.size > 0
        @ad_campaign_ids = redis_client.zrange(rtt_prefix + cookie, 0, -1)
      end
    end

    respond_to do |format|
      format.json { render json: { 'ad_campaign_ids' => @ad_campaign_ids.join(",") } }
    end
  end

end
