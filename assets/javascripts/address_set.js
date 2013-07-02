$(function(){
	
	$('.set-wrapper').on('click', '.delete', function(e) {
		var id = $(e.delegateTarget).data('id');
		console.log(id);
		var url = '/address_set/' + id
		$.ajax({
			url: url,
			type: 'DELETE',
			success: function(result) {
				console.log(result);
			}
		})
	})

	$('.set-wrapper').on('click', '.reload', function(e) {
		var id = $(e.delegateTarget).data('id');
		console.log(id);
		
		$(e.delegateTarget).load('/address_set/'+id+' .view-container', function(){
			console.log('loaded!');
		})
	})

})