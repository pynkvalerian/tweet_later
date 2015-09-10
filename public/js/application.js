$(document).ready(function() {

	// HIDES TWEET STATUS WHEN PAGE LOADED
  	$("#tweet_done").hide();
  	$('#tweet_in_progress').hide();

 	// WHEN SUBMIT TWEET
	$('form#ajax').on('submit', function(event){
		event.preventDefault();
		$('form#ajax').hide();

		// SEND POST REQUEST
		$.ajax({
			url: '/ajax_tweets',
			method: 'POST',
			dataType: "json",
			data: $(this).serialize()

		// RETURNS JID AFTER POSTED REQUEST
		}).done(function(response){
			var jid = response["jid"]
			var tweet = response["tweet"]

			// CHECKS WHETHER IT IS TWEETED
			isItDoneYet(jid, tweet)

			// CLEARS INPUT VALUE
			$('input[type="text"]').val("");

		});
	});

	$('button#tweet_again').on('click', function(){
		$("#tweet_done").hide();
		$('form#ajax').show();
	});
});

function isItDoneYet(jid, tweet){
	$.ajax({
		url: '/status/'+jid,
		method: 'GET',
	}).done(function(response){
		if(response === "true"){
			$('#tweet_in_progress').hide();
 			$("#tweet_done").show();
 			addTweet(tweet);
		}else{
			$('#tweet_in_progress').show();
			isItDoneYet(jid, tweet)
		}
	});
};

function addTweet(tweet){
	$('div.tweet:first-child').prepend(
		'<div class="new_tweet">\
		<dt>'+tweet+'</dt>\
		<dd> recently posted by you! </dd>\
		</div>'
	);
};