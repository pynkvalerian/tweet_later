$(document).ready(function() {
  
	$("#ajax").submit(function(event){
		
		event.preventDefault();

		$.ajax({
			url: '/ajax_tweet',
			method: 'POST',
			dataType: "json",
			data: $(this).serialize()
		}).done(function(response){
				$("#tweeted").append(
					'<p> Your tweet has been posted successfully! </p>'
					);
				$('.tweet:first-child').append(
					'<div class="tweet">\
					<dt>'+value["text"]+'</dt>\
   				<dd> posted on '+value["text_created_at"]+'</dd>\
   				</div>'
					);
			})
		})
	})

});
