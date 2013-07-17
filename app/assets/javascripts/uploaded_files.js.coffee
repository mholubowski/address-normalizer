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
      @next_step(answer)

    next_step: (answer) ->
      @current_step.decide_next(answer)

    finish: ->
      @active = false
      alert 'Step Wizard says...all done!'
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
      @option_b      = options.option_b || null
      @path_b        = options.path_b   || null

    start: ->
      @step_wizard.current_step = @
      @ask_question()

    ask_question: ->
      @render_html(@step_wizard.container_elem)

    render_html: (container_elem) ->
      container_elem.find('.question-text').html(@question_text)
      button_type = if @fork then 'yes-no' else 'NA'
      container_elem.find('.btn-container').html(@create_buttons(button_type))

    create_buttons: (type) ->
      switch type
        when 'NA'
          """
          <div class="btn" data-wizard_value="nil">Not Applicable</div>
          """
        when 'yes-no'
          """
          <div class="btn" data-wizard_value="true">Yes</div>
          <div class="btn" data-wizard_value="false">No</div>
          """

    decide_next: (answer) ->
      unless @fork then return @next_path()
      switch answer
        when @option_a then @path_a()
        when @option_b then @path_b()
        else console.log "#{answer} -> wrong input for STEP"

  # initialize like this
  window.wiz = new StepWizard $('#wizard-container')

  # Step 1
  step1_opts = {
    step_wizard: window.wiz,
    answer_for: 'single_column_address',
    question_text: 'Is your address info all in one column?',
    fork: true,
    next_path: null,
    option_a: true,
    path_a: (-> window.step1b.start()),
    option_b: false,
    path_b: (-> window.step2.start())
  }
  window.step1 = new Step(step1_opts)

  window.step2 = new Step window.wiz, 'street_index', 'What column is your street NAME in?', false, -> this.step_wizard.finish()
  # window.step3 = new Step window.wiz, 'street_index', 'What column is your street NAME in?', false, -> alert 'done'
  window.wiz.current_step = window.step1

  wiz = window.wiz

  # set up jQuery bindings to listen for answers
  $('#wizard-container').on 'click', '.btn', ->
    # check if the Wizard.active = true
    answer = $(@).data 'wizard_value'
    wiz.collect_answer(answer)



