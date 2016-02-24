class HomeController < ApplicationController
  before_filter :configure_client
  
  def index
    #array for all tweets
    @tweets = []
    #string for tweet w/ most favorites
    @top_tweet = ""
    #hash for each word in tweets w/ value number of occurences 
    @word_counts = {}
    #gets the last 200 tweets from Kanye
    tweets_init = @client.user_timeline("kanyewest", count: 200, include_entities: true)
    #if tweets were created today, the tweets are added to the @tweets array
    tweets_init.each do |tweet|
        @tweets << tweet if tweet.created_at.today?
    end
    #@word_counts is filled with all words and number of occurences, @top_tweet is filled with the tweet with the most favorites
    @tweets.each do |tweet|
      puts tweet
      count_words(tweet, @word_counts)
      @top_tweet = tweet if @top_tweet.blank? || @top_tweet.favorite_count < tweet.favorite_count
    end
    #sorts the hash by value (number of occurences)
    sorted = @word_counts.sort_by {|_key, value| value}
    #makes the hash an array of arrays and reverses it
    sorted_arr = sorted.to_a.reverse
    #cat is array that will hold the first five most used words
    cat = []
    #data is an array that will hold the first five most used words' number of occurences
    data = []
    #cat and data are filled 
    sorted_arr[0...5].each do |arr|
      cat << arr.first
      data << arr.last
    end
    #a chart is made with the top 5 most used words and occurences
    make_chart(cat, data)
  end
  
  def yesterday
    #array for all tweets
    @tweets = []
    #string for tweet w/ most favorites
    @top_tweet = ""
    #hash for each word in tweets w/ value number of occurences 
    @word_counts = {}
    #gets the last 200 tweets from Kanye
    tweets_init = @client.user_timeline("kanyewest", count: 200, include_entities: true) 
    #if tweets were created yesterday, the tweets are added to the @tweets array
    tweets_init.each do |tweet|
        @tweets << tweet if tweet.created_at.strftime("%d") == Date.yesterday.strftime("%d")
    end
    #@word_counts is filled with all words and number of occurences, @top_tweet is filled with the tweet with the most favorites
    @tweets.each do |tweet|
      count_words(tweet, @word_counts)
      @top_tweet = tweet if @top_tweet.blank? || @top_tweet.favorite_count < tweet.favorite_count
    end
    #sorts the hash by value (number of occurences)
    sorted = @word_counts.sort_by {|_key, value| value}
    #makes the hash an array of arrays and reverses it
    sorted_arr = sorted.to_a.reverse
    #cat is array that will hold the first five most used words
    cat = []
    #data is an array that will hold the first five most used words' number of occurences
    data = []
    #cat and data are filled 
    sorted_arr[0...5].each do |arr|
      cat << arr.first
      data << arr.last
    end
    #a chart is made with the top 5 most used words and occurences
    make_chart(cat, data)
  end
  
  def count_words(string, hash)
    black_list = ['the', 'a', 'of', 'on', 'with', 'got', 'to', 'and', 'that', 'do', 'some', 'be', 'is', 'been', 'one', 'by', "i'm", 'have', 'for']
    arr = string.text.downcase.split(' ')
    
    arr.each do |word|
      unless black_list.include? word
        if !hash.has_key? word 
          hash[word] = 1
        else
          hash[word] = hash[word] += 1
        end
      end
    end
  end
  
  def make_chart(cat, data)
    @chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: "Ye's Top 5")
      f.xAxis(categories: cat)
      f.series(name: "# times used", yAxis: 0, data: data)
    
      f.yAxis [
        {title: {text: "# of times used", margin: 70} },
      ]
    
      f.legend(align: 'right', verticalAlign: 'top', y: 75, x: -50, layout: 'vertical')
      f.chart({defaultSeriesType: "column"})
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