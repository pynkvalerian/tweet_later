class TweetWorker
  include Sidekiq::Worker

 	def perform(tweet_id)
 		tweet = Tweet.find(tweet_id)
 		puts "working-------------->"
		$twitter_client.access_token = tweet.user.access_token
		$twitter_client.access_token_secret = tweet.user.access_token_secret
		tweeted = $twitter_client.update(tweet.text)
		return tweeted
 	end

 	def self.job_is_complete(jid)
	  waiting = Sidekiq::Queue.new
	  working = Sidekiq::Workers.new
	  pending = Sidekiq::ScheduledSet.new
	  return false if pending.find { |job| job.jid == jid }
	  return false if waiting.find { |job| job.jid == jid }
	  return false if working.find { |process_id, thread_id, work| work["payload"]["jid"] == jid }
	  true
	end

end
