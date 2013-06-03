if $('body.features.index').length > 0
  $('#feature_name').autocomplete({
    source: $features
  }).after($('ul.ui-autocomplete').detach())

  $status = $('span[role=status]').detach()