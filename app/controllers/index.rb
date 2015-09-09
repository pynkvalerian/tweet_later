get '/' do
	erb :index
end

get '/login' do 
	redirect to('/auth/twitter')
end

get '/auth/twitter/callback' do
  env['omniauth.auth'] ? session[:admin] = true : halt(401,'Not Authorized')

  user = User.find_or_create_by(username: env['omniauth.auth']['info']['nickname'])
  user.access_token = env['omniauth.auth']['credentials']['token']
  user.access_token_secret = env['omniauth.auth']['credentials']['secret']
  user.save
  session[:username] = user.username

  redirect to("/users/#{user.username}")
end

get '/users/:username' do
  @user = User.find_by(username: session[:username])
  @tweets = @user.fetch_tweets!
  erb :user_page
end

post '/tweet' do
	if session[:username].nil?
		redirect to('/auth/twitter')
	else
		tweet = params[:tweet]
		@user = User.find_by(username: session[:username])
		$twitter_client.access_token = @user.access_token
		$twitter_client.access_token_secret = @user.access_token_secret

		$twitter_client.update(tweet)
		redirect to("/users/#{@user.username}")
	end
end

post '/ajax_tweets' do
	@user = User.find_by(username: session[:username])
	tweet = params["tweet"]
	$twitter_client.access_token = @user.access_token
	$twitter_client.access_token_secret = @user.access_token_secret

	$twitter_client.update(tweet)
	tweet.to_json
end

get '/logout' do
	session[:username] = nil
	redirect to('/')
end