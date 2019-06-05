$list = $('dl.sub-nav')
$options = $list.find('dd a')
$alert = $('p.alert-box').not('#notice')
$vehicles = $('.vehicle')

if $list.length > 0
  $options.click (e)->
    e.preventDefault()
    $('.active').removeClass('active')
    $(this).parent().addClass('active')
    if $alert.is(':visible')
      $alert.hide()
    value = $(this).html()
    if value == 'All'
      $vehicles.show()
      if $vehicles.length <= 0
        $alert.find('span').html('')
        $alert.show()
    else
      $vehicles.hide()
      selected = $('.vehicle.'+value)
      if selected.length > 0
        selected.show()
      else
        $alert.find('span').html(value)
        $alert.show()
$options.first().click();
