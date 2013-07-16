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

class StepWizard
  constructor: (@container_elem, @result_hash = step_results_hash) ->

  active: false
  current_step: null

  begin: ->
    @active = true
    @current_step.start()

  answer_to_current: (answer) ->
    @result_hash[this.current_step.answer_for] = answer
    this.nextStep(answer)

  nextStep: (answer) ->
    @current_step.decide_next(answer)

  finished: () ->
    @active = false
    alert 'Step Wizard says...all done!'
    # ajax update UploadedFile with the @result_hash


class Step extends StepWizard
  constructor: (@step_wizard, @answer_for, @question_text, @fork = false, @next_path, @option_a, @path_a, @option_b, @path_b) ->

  start: () ->
    @step_wizard.current_step = this
    this.ask_question()

  ask_question: () ->
    this.render_html(@step_wizard.container_elem)

  render_html: (container_elem) ->
    container_elem.html(@question_text)

  decide_next: (answer) ->
    unless @fork then return @next_path()
    switch answer
      when @option_a then @path_a()
      when @option_b then @path_b()
      else console.log 'wrong input for STEP'


# initialize like this
jQuery ->
  window.wiz = new StepWizard $('#wizard-container')

  window.step1 = new Step window.wiz, 'number_index', 'Is your address info all in one column?', true, null, 'true', (-> window.step2.start()), 'false', (-> window.step2.start())
  # window.full_address_index = new Step window.wiz, 'number_index', 'Please select the address column', false, -> @step_wizard.finished()

  window.step2 = new Step window.wiz, 'street_index', 'What column is your street NAME in?', false, -> window.step3.start()
  # window.step3 = new Step window.wiz, 'street_index', 'What column is your street NAME in?', false, -> alert 'done'
