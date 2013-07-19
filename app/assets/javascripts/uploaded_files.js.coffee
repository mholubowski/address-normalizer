# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# ---- Column Selector ----
jQuery ->
  # $('#column-selector-table').on 'click','th', ->
  #   id = $('#column-selector-table').data('id')
  #   $('#column-selector-table th').removeClass 'active'
  #   $(this).addClass 'active'
  #   address_index = $('#column-selector-table th.active').index()
  #   $.ajax({
  #     url: "/uploaded_files/#{id}",
  #     type: "PATCH",
  #     data: {address_index: address_index}
  #   }).done (data) ->
  #     console.log 'DONE!'
  #   readyToProceed()



  step_results_hash = {
    single_column_address: false,
    single_column_index: null,

    number_index: null,
    street_index: null,
    street_type_index: null,
    unit_index: null,
    unit_prefix_index: null,
    suffix_index: null,
    prefix_index: null,
    city_index: null,
    state_index: null,
    postal_code_index: null,
    postal_code_ext_index: null
  }

# - Wizard handles getting input from user...via jQuery bindings
# - Steps handle asking questions and deciding course of action based on answer
  class StepWizard
    constructor: (@container_elem, @result_hash = step_results_hash) ->

    active: false
    current_step: null

    begin: ->
      @active = true
      @current_step.start()

    collect_answer: (answer) ->
      @result_hash[@current_step.answer_for] = answer
      @update_view()
      @next_step(answer)

    update_view: ->
      console.log(@result_hash)
      wrap = $('#response-tracker .container')
      html = '<dl>'
      for key, value of @result_hash
        if value?
          html += "<dt><span class='label label-success'>#{key}</span></dt>"
          html += "<dd>#{value}</dd>"
        else
          # html += "<dt><span class='label label-warning'>#{key}</span></dt>"
          # html += "<dd> - </dd>"
        
      html += '</dl>'
      wrap.html(html)

    next_step: (answer) ->
      @current_step.decide_next(answer)

    finish: ->
      @active = false
      @send_data_to_server()
      @readyToProceed()

    send_data_to_server: ->
      # vulnerability? just change the id?
      id = $('#column-selector-table').data('id')
      results = JSON.stringify(@result_hash)
      $.ajax({
        url: "/column_informations",
        type: "POST",
        dataType: 'json',
        data: {column_info: results, file_id: id}
        }).done (data) ->
          console.log(data)
    
    readyToProceed: ->
      $('.status-wrapper').replaceWith @status('ready')
      $('i.icon-arrow-right').replaceWith @greenCheckMark()
      $('.process').removeClass 'disabled'
      $('.proceed-btn').show 'slow'

    status: (type) ->
      switch type
        when 'ready'
          """
          <div class="status-wrapper">Status: <span class="label label-success">Ready!</span></div>
          """
        when 'pending'
          """
          <div class="status-wrapper">Status: <span class="label label-warning">Pending</span></div>
          """
    greenCheckMark: -> '<i class="icon-check icon-3x color-green"></i>'

      # ajax update UploadedFile with the @result_hash


  class Step extends StepWizard
    constructor: (options) ->
      @step_wizard   = options.step_wizard
      @answer_for    = options.answer_for
      @question_text = options.question_text
      @fork          = options.fork || false
      @next_path     = options.next_path
      @option_a      = options.option_a || null
      @path_a        = options.path_a   || null
      @option_b      = if options.option_b? then options.option_b else null
      @path_b        = options.path_b   || null

    start: ->
      @step_wizard.current_step = @
      @ask_question()

    ask_question: ->
      @render_html(@step_wizard.container_elem)

    render_html: (container_elem) ->
      header = container_elem.find('.step-header')
      step = header.html()
      step = parseInt(step.replace( /^\D+/g, '')) + 1
      if step < 10 then header.html("Step #{step}") else header.html("Step #{step} <small>(almost done!)</small>") 

      container_elem.find('.question-text').html(@question_text)
      button_type = if @fork then 'yes-no' else 'NA'
      container_elem.find('.btn-container').html(@create_buttons(button_type))

      # TODO example address
      # container_elem.find('.examples').html('<div>7462 Denrock <span class="color-green strong">Ave</span> Los Angeles, CA 90045</div>')

    create_buttons: (type) ->
      switch type
        when 'NA'
          """
          <div class="btn" data-wizard_value="">No Column</div>
          """
        when 'yes-no'
          """
          <div class="btn btn-info" data-wizard_value="true">Yes</div>
          <div class="btn btn-info" data-wizard_value="false">No</div>
          """
    decide_next: (answer) ->
      unless @fork then return @next_path()
      switch answer
        when @option_a then @path_a()
        when @option_b then @path_b()
        else console.log "#{answer} -> wrong input for STEP"

  # initalize wizard
  dom_wrapper = $('#wizard-container')
  window.wiz  = new StepWizard( dom_wrapper )

  # ask if address is in one or multiple columns
  step0_opts = {
    step_wizard: window.wiz,
    answer_for: 'single_column_address',
    question_text: 'Is your address info all in one column?',
    fork: true,
    next_path: null,
    option_a: true,
    path_a: (-> step0b.start()),
    option_b: false,
    path_b: (-> step1.start())
  }
  step0 = new Step(step0_opts)

  # if ONE COLUMN, ask which column
  step0b_opts = {
    step_wizard: window.wiz,
    answer_for: 'single_column_index',
    question_text: 'In which column is the <strong>Address</strong>? <small>(Click above)</small>',
    fork: false,
    next_path: (-> @step_wizard.finish()),
  }
  step0b = new Step(step0b_opts)

  # if multiple columns, begin asking for each attribute
  step1_opts = {
    step_wizard: window.wiz,
    answer_for: 'number_index',
    question_text: 'In which column is the <strong>Street Number</strong>? <small>(Click above)</small>',
    fork: false,
    next_path: (-> step2.start()),
  }
  step1 = new Step(step1_opts)

  step2_opts = {
    step_wizard: window.wiz,
    answer_for: 'street_index',
    question_text: 'In which column is the <strong>Street Name</strong>?',
    fork: false,
    next_path: (-> step3.start()),
  }
  step2 = new Step(step2_opts)

  step3_opts = {
    step_wizard: window.wiz,
    answer_for: 'street_type_index',
    question_text: 'In which column is the <strong>Street Type</strong>?',
    fork: false,
    next_path: (-> step4.start()),
  }
  step3 = new Step(step3_opts)

  step4_opts = {
    step_wizard: window.wiz,
    answer_for: 'unit_index',
    question_text: 'In which column is the <strong>Unit Number</strong>?',
    fork: false,
    next_path: (-> step8.start()),
  }
  step4 = new Step(step4_opts)

  # TODO unit prefix?
  ###
  step5_opts = {
    step_wizard: window.wiz,
    answer_for: 'unit_prefix_index',
    question_text: 'In which column is the <strong>Street Number</strong>?',
    fork: false,
    next_path: (-> step6.start()),
  }
  step5 = new Step(step5_opts)

  # TODO suffix?
  step6_opts = {
    step_wizard: window.wiz,
    answer_for: 'suffix_index',
    question_text: 'In which column is the <strong>Street Number</strong>?',
    fork: false,
    next_path: (-> step7.start()),
  }
  step6 = new Step(step6_opts)

  # TODO prefix?
  step7_opts = {
    step_wizard: window.wiz,
    answer_for: 'prefix_index',
    question_text: 'In which column is the <strong>Street Number</strong>?',
    fork: false,
    next_path: (-> step8.start()),
  }
  step7 = new Step(step7_opts)
  ###

  # city
  step8_opts = {
    step_wizard: window.wiz,
    answer_for: 'city_index',
    question_text: 'In which column is the <strong>City</strong>?',
    fork: false,
    next_path: (-> step9.start()),
  }
  step8 = new Step(step8_opts)

  # state
  step9_opts = {
    step_wizard: window.wiz,
    answer_for: 'state_index',
    question_text: 'In which column is the <strong>State</strong>?',
    fork: false,
    next_path: (-> step10.start()),
  }
  step9 = new Step(step9_opts)

  # postal code
  step10_opts = {
    step_wizard: window.wiz,
    answer_for: 'postal_code_index',
    question_text: 'In which column is the <strong>Postal Code</strong>?',
    fork: false,
    next_path: (-> step11.start()),
  }
  step10 = new Step(step10_opts)

  # postal code extension
  step11_opts = {
    step_wizard: window.wiz,
    answer_for: 'postal_code_ext_index',
    question_text: 'In which column is the <strong>Postal Code Extension</strong>?',
    fork: false,
    next_path: (-> @step_wizard.finish()),
  }
  step11 = new Step(step11_opts)

  window.wiz.current_step = step0

  wiz = window.wiz
  wiz.begin()

  # set up jQuery bindings to listen for answers
  $('#wizard-container').on 'click', '.btn', ->
    # check if the Wizard.active = true
    answer = $(@).data 'wizard_value'
    wiz.collect_answer(answer)

  $('#column-selector-table').on 'click', 'th', ->
    # check if the Wizard.active = true
    answer = $(@).data 'wizard_value'
    wiz.collect_answer(answer)



