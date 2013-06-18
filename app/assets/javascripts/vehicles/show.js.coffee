# vars
$photo = $('.photo-box .photo')
$photos = $('.photo-box .photos')
$images = $photos.find('img')
$slider = $('#slider')
$html = $('html')
$body = $('body')
$close = $('.reveal-modal-bg, .close-reveal-modal')
$infoCap = $('.information-caption')

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
    $infoCap.height($slider.height())
    $infoCap.width($slider.width())
  , 500);

next = ->
  $slider.data('nivoslider').nivo_run($slider, $slider.children(), $settings, 'next');

prev = ->
  $slider.data('nivo:vars').currentSlide -= 2
  $slider.data('nivoslider').nivo_run($slider, $slider.children(), $settings, 'prev');

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
  $body.append($('#gallery-modal').detach());

  $slider.nivoSlider($settings)
  $('#gallery-modal *').disableSelection()

  if $html.hasClass('ie8') || $html.hasClass('ie7') || $html.hasClass('ie6')
    $('.slider-wrapper').hover ->
      $infoCap.css('filter','alpha(opacity=100)')
    ,->
      $infoCap.css('filter','alpha(opacity=0)')