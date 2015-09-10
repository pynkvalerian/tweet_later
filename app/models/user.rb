class User < ActiveRecord::Base
  has_many :tweets

# FETCH TWEETS FROM USER'S TWITTER TIMELINE
  def fetch_tweets!
    $twitter_client.access_token = self.access_token
    $twitter_client.access_token_secret = self.access_token_secret
  	@tweets = $twitter_client.user_timeline(self.username)
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

# CHECK IF DB TWEETS ARE OUT OF DATE
  def tweets_stale?
  	now = DateTime.now
  	time_zone_diff = 8 * 60 * 60
  	fifteen_mins = 15 * 60
  	time_difference = now.to_i - (self.tweets.first.created_at).to_i + time_zone_diff
  	return true if time_difference > fifteen_mins
  end

# CHECK IF USER IS NOT ACTIVE ON TWITTER (LAST TWEET > 6 MONTHS AGO)
  def not_ancient_tweeter?
  	six_months = Date.today - (6*30)
  	last_tweet_time = Date.parse(self.tweets.first.text_created_at)
  	return last_tweet_time > six_months
  end

# ASSIGN WORKER TO POST TWEET AT SPECIFIED TIMES
  def tweet(status, time)
      my_tweet = self.tweets.create(text: status)
      if time.to_i == 0
        TweetWorker.perform_async(my_tweet.id)
      elsif time.to_i > 0
        TweetWorker.perform_at(time.seconds.from_now, my_tweet.id)
      end
  end
  
end
