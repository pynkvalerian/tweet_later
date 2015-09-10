$(document).ready(function() {
  
	$('form#ajax').on('submit', function(event){
		event.preventDefault();

		$.ajax({
			url: '/ajax_tweets',
			method: 'POST',
			dataType: "json",
			data: $(this).serialize()
		}).done(function(response){
				$("#tweeted").append(
					'<p> Your tweet has been posted successfully! </p>'
					);
				debugger;
				$('.tweet').prepend(
					'<div class="tweet">\
					<dt>'+response+'</dt>\
   				<dd> posted on '+Date($.now())+'</dd>\
   				</div>'
					);
			
		});
	});

});
