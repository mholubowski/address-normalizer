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

	$('.set-wrapper').on('click', '.reload', function(e) {
		$this = $(e.delegateTarget)
		var id = $this.data('id');
		
		$this.load('/address_set/'+id+' .view-container', function(){
			console.log('loaded!');
		})
	})

})