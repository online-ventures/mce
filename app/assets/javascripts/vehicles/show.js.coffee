$photo = $('.photo-box .photo')
$photos = $('.photo-box .photos')
$images = $photos.find('img')
$slider = $('#slider')

# define function
switchimg = (src) ->
  $photo.css('background-image', 'url('+src+')')

switchimg($photo.attr('data-src'))

$images.hover ->
  switchimg($(this).attr('data-src'))

$images.click ->
  $slider.find('.nivo-main-image').attr('src',$(this).attr('data-src'))



$(document).ready ->
  $slider.nivoSlider({
    effect: 'fade'
    startSlide: 0
    randomStart: false
    animSpeed: 100
    pauseOnHover: true
    pauseTime: 2000
  })