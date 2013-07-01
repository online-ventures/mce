if $('body.features.index').length > 0
  $max_val += 1;
  $('#feature_name').autocomplete({
    source: $features
  }).after($('ul.ui-autocomplete').detach())

  $status = $('span[role=status]').detach()

  $form = $('form.edit_vehicle')

  $form.submit ->
    console.log 'Form Submitted!'
    html = "<div class='large-10 small-centered columns feature subable on-probation' data-id='"+$max_val+"'><a class='secondary button left'><i class='foundicon-enclosed-minus default'></i><span>"+$("#feature_name").val()+"</span></a></div>"
    $('.vehicle .list').prepend(html)
    setTimeout(->
      $("#feature_name").val('')
    ,100);

  $('.feature.addable').click ->
    $('.vehicle .list').prepend($(this).detach())
  $('.feature.subable').click ->
    $('.system .list').prepend($(this).detach())