selects = $('#vehicle_make_id, #vehicle_model_id')
textboxes = $('#make_name, #model_name')

for select in selects
  $(select).change {textbox: textboxes[_i]}, (event)->
    textbox = event.data.textbox
    console.log $(textbox).is(':hidden')
    if $(this).val() == '' and $(textbox).is(':hidden')
      $(textbox).slideDown(100)
    else if $(this).val() != '' and $(textbox).is(':visible')
      $(textbox).slideUp(100)
  .change()