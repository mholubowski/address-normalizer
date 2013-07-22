# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# --- Exporter ---
jQuery ->
  $('.exporter-wrapper').on 'click', '.btn', (e) ->
    id = $('.exporter-wrapper').data 'id'
    export_type = e.currentTarget.textContent
    $.ajax({
      url: "/address_sets/exporter",
      type: "GET",
      data: { export_type: export_type, id: id }
    }).done (data) ->
      $('.exporter-wrapper').html(data)
      styleExporterTable(export_type)

  styleExporterTable = (export_type) ->
    # TODO make some cool stylings
    console.log "styling for export_type: #{export_type}"
