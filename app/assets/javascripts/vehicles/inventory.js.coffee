$list = $('dl.sub-nav')
$options = $list.find('dd a')
$alert = $('p.alert-box')
$vehicles = $('.vehicle')

if $list.length > 0
  $options.click (e)->
    e.preventDefault()
    $('.active').removeClass('active')
    $(this).parent().addClass('active')
    console.log $(this).parent()
    if $alert.is(':visible')
      $alert.hide()
    value = $(this).html().toLowerCase()
    if value == 'all'
      $vehicles.show()
    else
      $vehicles.hide()
      selected = $('.vehicle.'+value)
      if selected.length > 0
        selected.show()
      else
        $alert.find('span').html(value)
        $alert.show()