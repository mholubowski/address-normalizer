$(function(){
	
	$('.set-wrapper').on('click', '.delete', function(e) {
		var hash = $(e.delegateTarget).data('hash');
		console.log(hash);
		var url = '/address_set/' + hash
		$.ajax({
			url: url,
			type: 'DELETE',
			success: function(result) {
				console.log(result);
			}
		})
	})

})