get '/:username' do
  @user = User.find_or_create_by(username: params[:username])
  @tweets = @user.fetch_tweets!
  erb :index
end

# post '/ajax_tweets' do
# 	@user = User.find_or_create_by(username: params["username"])

# 	if @user.tweets.empty?
# 		@user.fetch_tweets!
# 	elsif @user.tweets_stale? && @user.not_ancient_tweeter?
# 		@user.fetch_tweets!
# 	end

# 	tweets = @user.tweets.limit(10)
# 	tweets.to_json( :only => [:text, :text_created_at])

# end

post '/tweet' do
	tweet = params[:tweet]
	@user = User.find_by(username: "pingthedreamer")
	@user.tweets.send_tweets(tweet)
	redirect to("/#{@user.username}")
end