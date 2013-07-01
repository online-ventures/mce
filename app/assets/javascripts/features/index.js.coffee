if $('body.features.index').length > 0
  $ajax_requests = {}
  $max_val += 1;
  $form = $('form.edit_vehicle')
  $save = $('input[type=submit].button.postfix')

  $('#feature_name').autocomplete({
    source: $features
  }).after($('ul.ui-autocomplete').detach())
  $status = $('span[role=status]').detach()


  #$save.click (e)->
  #  e.preventDefault()
  #  $(this).val('Saving...')
  #  $dots = setInterval(->
  #    if $save.val().substr(-3,3) == '...'
  #      $save.val('Saving')
  #    else
  #      $save.val($save.val()+'.')
#
  #    if $.isEmptyObject($ajax_requests)
  #      clearInterval($dots)
  #      $save.val('Saved')
  #      window.location = window.location.href.slice(0,-8)+'edit'
  #  ,500);

  $form.on('ajax:beforeSend', (event,xhr)->
    $ajax_requests[$max_val] = xhr
  ).on('ajax:complete', ->
    delete $ajax_requests[$max_val]
  )
  $form.submit ->
    html = "<div class='large-10 small-centered columns feature subable on-probation'><a class='secondary button left'><i class='foundicon-enclosed-minus default'></i><span>"+$("#feature_name").val()+"</span></a></div>"
    $('.vehicle .list').prepend(html)
    setTimeout(->
      $("#feature_name").val('')
    ,50);

  $('.feature.addable').click ->
    $('.vehicle .list').prepend($(this).detach())
  $('.feature.subable').click ->
    $('.system .list').prepend($(this).detach())

  $('.feature').on('ajax:beforeSend', (event, xhr, status)->
    $ajax_requests[$(this).attr('data-id')] = xhr
  ).on('ajax:complete', ->
    delete $ajax_requests[$(this).attr('data-id')]
  )