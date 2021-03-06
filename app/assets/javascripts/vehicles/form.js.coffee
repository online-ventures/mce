$make_select = $('#vehicle_make_id')
$model_select = $('#vehicle_model_id')
selects = $('#vehicle_make_id, #vehicle_model_id')
textboxes = $('#make_name, #model_name')

textboxes.hide()

i = 0
for select in selects
  $(select).change {textbox: textboxes[i]}, (event)->
    textbox = event.data.textbox
    if $(this).val() == '' and $(textbox).is(':hidden')
      $(textbox).slideDown(100).val('')
    else if $(this).val() != ''
      $(textbox).val($(this).find('option:selected').text())
      if $(textbox).is(':visible')
        $(textbox).slideUp(100)
  .change()
  i += 1


put_into_select = (select, options, preface=[])->
  select.html('');
  dropdown = $('div[data-id='+select.attr('data-id')+']');
  list = dropdown.find('ul')
  list.html('');
  if preface.length > 0
    select.append('<option value="'+preface[0]+'">'+preface[1]+'</option>')
    list.append('<li>'+preface[1]+'</li>')
    dropdown.find('a.current').html(preface[1])
  for option in options
    select.append("<option value='"+option[0]+"'>"+option[1]+"</option>")
    list.append('<li>'+option[1]+'</li>')
  select.change()


$make_select.change ->
  current = $model_select.find('option:selected').text()
  put_into_select($('#vehicle_model_id'), $makes[$(this).val()], ['', 'Create New Model'])
  old_current = $model_select.find('option:contains('+current+')')
  if old_current.length > 0
    $model_select.val(old_current.attr('value'))
