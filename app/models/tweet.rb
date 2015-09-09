class Tweet < ActiveRecord::Base
  belongs_to :user

  # def self.send_tweets(status)
  #   @tweet = $twitter_client.update(status)
  # end

end
