get '/' do
	erb :index
end

# LOG IN VIA TWITTER
get '/login' do 
	redirect to('/auth/twitter')
end

# USER LOG OUT / CLEAR SESSION
get '/logout' do
	session[:username] = nil
	redirect to('/')
end

# CALLBACK AFTER TWITTER LOG IN 
get '/auth/twitter/callback' do
  env['omniauth.auth'] ? session[:admin] = true : halt(401,'Not Authorized')

  user = User.find_or_create_by(username: env['omniauth.auth']['info']['nickname'])
  user.access_token = env['omniauth.auth']['credentials']['token']
  user.access_token_secret = env['omniauth.auth']['credentials']['secret']
  user.save
  session[:username] = user.username

  redirect to("/users/#{user.username}")
end

# USER HOME PAGE
get '/users/:username' do
  @user = User.find_by(username: session[:username])
  @tweets = @user.fetch_tweets!
  erb :user_page
end

# AJAX POST TWEET
post '/ajax_tweets' do  
	@user = User.find_by(username: session[:username])
	tweet = params["tweet"]
	time = params["time"]

	data = {}
	data["jid"] = @user.tweet(tweet, time)
	data["tweet"] = tweet
	data.to_json
end

# IS IT DONE YET?
get '/status/:job_id' do
	status = TweetWorker.job_is_complete(params[:job_id])
	if status == true
		data = "true"
	elsif status == false
		data = "false"
	end
end

