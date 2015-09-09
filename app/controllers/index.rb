get '/:username' do
  @user = User.find_or_create_by(username: params[:username])
  @tweets = @user.fetch_tweets!
  erb :index
end

post '/tweet' do
	tweet = params[:tweet]
	@user = User.find_by(username: "pingthedreamer")
	@user.tweets.send_tweets(tweet)
	redirect to("/#{@user.username}")
end

post '/ajax_tweets' do
	@user = User.find_by(username: "pingthedreamer")
	tweet = params["tweet"]
	@user.tweets.send_tweets(params["tweet"])
	tweet.to_json
end