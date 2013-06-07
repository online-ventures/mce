# vars
$photo = $('.photo-box .photo')
$photos = $('.photo-box .photos')
$images = $photos.find('img')
$slider = $('#slider')
$body = $('body')
$close = $('.reveal-modal-bg, .close-reveal-modal')

# functions
switchimg = (src) ->
  $photo.css('background-image', 'url('+src+')')

slideTo = (slideId) ->
  $slider.data('nivo:vars').currentSlide = slideId - 2

$close.click ->
  $body.removeClass('full');
  $body.unbind('click')

close = ->
  $close.click()

open = ->
  $body.addClass('full').scrollTop(0);
  $body.click (e)->
    if e.clientX > $body.width() / 2
      next()
    else
      prev()

next = ->
  $slider.find('a.nivo-nextNav').click()

prev = ->
  $slider.find('a.nivo-prevNav').click()



# doing stuff
switchimg($photo.attr('data-src'))

$images.hover ->
  switchimg($(this).attr('data-src'))

$images.click ->
  slideTo($(this).attr('data-slide-id'))
  open()

$photo.click ->
  open()


$body.keydown (e)->
  if e.which in [13, 27] # Esc
    close()
  if e.which == 39 # right arrow
    next()
  if e.which == 37 # left arrow
    prev()

$(document).ready ->
  $nivo = $slider.nivoSlider({
    effect: 'none'
    startSlide: 0
    randomStart: false
    animSpeed: 100
    pauseOnHover: true
    pauseTime: 2000
  })