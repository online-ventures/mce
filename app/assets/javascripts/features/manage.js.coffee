if $('body.manage.features').length > 0
  $sortthing = $('.features.list').sortable({
    axis: 'y'
    placeholder: 'empty-spot'
    opacity: 0.5
    tolerance: 'pointer'
    update: (event, ui)->
      $sortthing.sortable "disable"
      $sortthing.addClass('disabled')
      feature_id = ui.item.attr('data-id')
      feature_to = $('ol li').index(ui.item) + 1
      $.ajax {
        url: '/features/'+feature_id+'/to/'+feature_to
        type: 'POST'
        success: ->
          $sortthing.sortable "enable"
          $sortthing.removeClass('disabled')
      }

  }).disableSelection()