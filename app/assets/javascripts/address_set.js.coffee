# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# --- Exporter ---
jQuery ->
  $('.exporter-wrapper').on 'click', '.btn', (e) ->
    type = e.currentTarget.textContent
    $.ajax({
      url: "/address_sets/exporter",
      type: "GET",
      data: {type: type}
    }).done (data) ->
      $('.exporter-wrapper').html(data)
      styleExporterTable(type)

  styleExporterTable = (type) ->
    # TODO make some cool stylings
    console.log "styling for type: #{type}"
