class User < ActiveRecord::Base
  has_many :tweets

  def fetch_tweets!
  	@tweets = $twitter_client.user_timeline(self.username)
  	byebug
    if self.tweets.count == 0
	  	@tweets.each do |tweet|
	  		self.tweets.create(text: tweet.text, text_created_at: tweet.created_at)
  		end
  	elsif tweets_stale? && not_ancient_tweeter?
  		self.tweets.delete_all
  		@tweets.each do |tweet|
  	  		self.tweets.create(text: tweet.text, text_created_at: tweet.created_at)
  		end
  	end
    @tweets = self.tweets
  end

  def tweets_stale?
  	now = DateTime.now
  	time_zone_diff = 8 * 60 * 60
  	fifteen_mins = 15 * 60
  	time_difference = now.to_i - (self.tweets.first.created_at).to_i + time_zone_diff
  	return true if time_difference > fifteen_mins
  end

  def not_ancient_tweeter?
  	six_months = Date.today - (6*30)
  	last_tweet_time = Date.parse(self.tweets.first.text_created_at)
  	return last_tweet_time > six_months
  end
  
end
