$photo = $('.photo-box .photo')
$photos = $('.photo-box .photos')
$images = $photos.find('img')
$slider = $('#slider')
$body = $('body')
$close = $('.reveal-modal-bg, .close-reveal-modal')

# define function
switchimg = (src) ->
  $photo.css('background-image', 'url('+src+')')

switchimg($photo.attr('data-src'))

$images.hover ->
  switchimg($(this).attr('data-src'))

$images.click ->
  $.slideTo($(this).attr('data-slide-id'))
  $body.addClass('full').scrollTop(0);

$photo.click ->
  $body.addClass('full').scrollTop(0);

$close.click ->
  $body.removeClass('full');

$body.keydown (e)->
  if e.which in [13, 27]
    console.log('closed')
    $close.click()
  if e.which == 39
    $slider.find('a.nivo-nextNav').click()
  if e.which == 37
    $slider.find('a.nivo-prevNav').click()




$.slideTo = (idx) ->
  $slider.data('nivo:vars').currentSlide = idx - 2
  #$('#slider a.nivo-nextNav').click

$(document).ready ->
  $nivo = $slider.nivoSlider({
    effect: 'fade'
    startSlide: 0
    randomStart: false
    animSpeed: 100
    pauseOnHover: true
    pauseTime: 2000
  })