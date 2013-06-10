#console.log $makes

$make_select = $('#vehicle_make_id')
$model_select = $('#vehicle_model_id')
selects = $('#vehicle_make_id, #vehicle_model_id')
textboxes = $('#make_name, #model_name')

textboxes.hide()

for select in selects
  $(select).change {textbox: textboxes[_i]}, (event)->
    textbox = event.data.textbox
    if $(this).val() == '' and $(textbox).is(':hidden')
      $(textbox).slideDown(100).val('')
    else if $(this).val() != ''
      $(textbox).val($(this).find('option:selected').text())
      if $(textbox).is(':visible')
        $(textbox).slideUp(100)
  .change()


put_into_select = (select, options, preface=[])->
  select.html('');
  if preface.length > 0
    select.append('<option value="'+preface[0]+'">'+preface[1]+'</option>')
  console.log options
  for option in options
    console.log option
    select.append("<option value='"+option[0]+"'>"+option[1]+"</option>")
  select.change()


$make_select.change ->
  current = $model_select.find('option:selected').text()
  put_into_select($('#vehicle_model_id'), $makes[$(this).val()], ['', 'Create New Model'])
  old_current = $model_select.find('option:contains('+current+')')
  if old_current.length() > 0
    $model_select.val(old_current.attr('value'))