class HomeController < ApplicationController
  before_filter :configure_client
  
  def index
    @tweets = []
    tweets_init = @client.user_timeline("kanyewest", count: 200) 
    tweets_init.each do |tweet|
       if tweet.created_at.today? 
           @tweets << tweet
       end
    end
  end
  
  private 
  
  def configure_client
    @client = Twitter::REST::Client.new do |config|
        config.consumer_key        = "qzfTGNnwf8staHOW9yRNyHtAR"
        config.consumer_secret     = "3cy8XwpLMFc4zuJMTEU0VELtNTewaJvJ70cYjnHcOZqo6WsAoi"
        config.access_token        = "210696210-ZM3ZQFAPxdiDAd3BcVG7eTaVZohrTBdhm1QK9UGR"
        config.access_token_secret = "3Ie4Yxds6Atv5DhBPFvYxKQW9sHtDKjveRFGQxzegimRA"
      end
  end
end