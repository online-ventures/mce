# vars
$photo = $('.photo-box .photo')
$photos = $('.photo-box .photos')
$images = $photos.find('img')
$slider = $('#slider')
$body = $('body')
$close = $('.reveal-modal-bg, .close-reveal-modal')
$settings = {
    effect: 'none'
    startSlide: 0
    randomStart: false
    animSpeed: 100
    pauseTime: 3000
    manualAdvance: true
    directionNav: false

    slices: 15
    boxCols: 8
    boxRows: 4
    controlNav: true
    controlNavThumbs: false
    pauseOnHover: true
    prevText: 'Prev'
    nextText: 'Next'
    beforeChange: ->
    afterChange: ->
    slideshowEnd: ->
    lastSlide: ->
    afterLoad: ->
  }

# functions
switchimg = (src) ->
  $photo.css('background-image', 'url('+src+')')

slideTo = (slideId) ->
  $slider.data('nivo:vars').currentSlide = (slideId - 2)
  if $slider.data('nivo:vars').currentSlide < 0
    $slider.data('nivo:vars').currentSlide = 0
  next()

$close.click ->
  $body.removeClass('full')
  $body.unbind('click')

close = ->
  $close.click()

open = ->
  $body.addClass('full').scrollTop(0);
  $body.click (e)->
    # Don't change for thumbnail clicks, or nav button clicks
    unless $(e.target).is('.photos img') or $(e.target).is('.photo') or $(e.target).is('a.nivo-nextNav') or $(e.target).is('a.nivo-prevNav')
      if e.clientX > $body.width() / 2
        next()
      else
        prev()
  setTimeout(->
    $('.information-caption').height($slider.height())
    $('.information-caption').width($slider.width())
  , 500);

next = ->
  console.log 'next()'
  $slider.data('nivoslider').nivo_run($slider, $slider.children(), $settings, 'next');

prev = ->
  console.log 'prev()'
  $slider.data('nivo:vars').currentSlide -= 2
  $slider.data('nivoslider').nivo_run($slider, $slider.children(), $settings, 'prev');

$('.nivo-nextNav').click ->
  console.log 'clicker'

$('.nivo-prevNav').click ->
  console.log 'clicker'

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
  $slider.nivoSlider($settings)
  $('#gallery-modal *').disableSelection()