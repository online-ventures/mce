$('.alert-box').hide()
if $('body.features.index').length > 0
  $ajax_requests = {}
  $max_val += 1;
  $form = $('form.edit_vehicle')
  $save = $('button.button.postfix')

  $('#feature_name').autocomplete({
    source: $features
  }).after($('ul.ui-autocomplete').detach()).keypress((e)->
    code = e.keyCode || e.which;
    if (code == 13)
      e.preventDefault();
      $("form").submit();
  )
  $status = $('span[role=status]').detach()


  $save.click (e)->
    $(this).html('Saving...')
    $dots = setInterval(->
      if $save.html().substr(-3,3) == '...'
        $save.html('Saving')
      else
        $save.html($save.html()+'.')
      if $.isEmptyObject($ajax_requests)
        clearInterval($dots)
        $save.html('Saved')
        window.location = window.location.href.slice(0,-8)+'edit'
    ,500);

  $form.on('ajax:beforeSend', (event,xhr)->
    $ajax_requests[$max_val] = xhr
  ).on('ajax:complete', ->
    delete $ajax_requests[$max_val]
  )
  $form.submit ->
    feature = $("#feature_name").val()
    if feature.length < 3
      $('.alert-box').slideDown().html('Features should be at least 3 characters long.').delay(2000).slideUp()
    else
      selector = '.feature span:contains('+feature+')'
      console.log selector
      $existing = $(selector)
      if $existing.length > 0 and $existing.first().parents('.system').length == 0
        $('body,html').animate({scrollTop: $existing.offset().top - 200 },700);
        $existing.parent().animate({'background-color': '#FFFF00' }).delay(1000).animate({'background-color': '#e9e9e9'})
      else
        $('.system '+selector).parents('div.feature').hide()
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