# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# ---- Column Selector ----
jQuery ->
  $('#column-selector-table').on 'click','th', ->
    id = $('#column-selector-table').data('id')
    $('#column-selector-table th').removeClass 'active'
    $(this).addClass 'active'
    address_index = $('#column-selector-table th.active').index()
    $.ajax({
      url: "/uploaded_files/#{id}",
      type: "PATCH",
      data: {address_index: address_index}
    }).done (data) ->
      console.log 'DONE!'
    readyToProceed()

  readyToProceed = () ->
    $('.status-wrapper').replaceWith status('ready')
    $('i.icon-arrow-right').replaceWith greenCheckMark()
    $('.process').removeClass 'disabled'
    $('.proceed-btn').show 'slow'

  status = (type) ->
    switch type
      when 'ready'
        """
        <div class="status-wrapper">Status: <span class="label label-success">Ready!</span></div>
        """
      when 'pending'
        """
        <div class="status-wrapper">Status: <span class="label label-warning">Pending</span></div>
        """
  greenCheckMark = -> '<i class="icon-check icon-3x color-green"></i>'

