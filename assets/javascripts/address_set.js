$(function(){

	$('.set-wrapper').on('click', '.delete', function(e) {
		$this = $(e.delegateTarget)
		var id = $this.data('id');
		var url = '/address_set/' + id
		$.ajax({
			url: url,
			type: 'DELETE',
			success: function(result) {
				$this.hide('fast', function(){$this.remove});
			}
		})
	})

	$('.set-wrapper').on('click', '.export-simple', function(e) {
		$this = $(e.delegateTarget)
		var id = $this.data('id');
		var url = '/address_set/'+id+'/simple-export';
		$.ajax({
			url: url,
			type: 'GET',
			success: function(result) {
				console.log('done! ' + result);
			}
		})
	})



})
