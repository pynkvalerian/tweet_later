class TweetWorker < ActiveRecord::Base
  include Sidekiq::Worker

 
end
