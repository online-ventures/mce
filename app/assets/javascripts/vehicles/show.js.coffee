# vars
$html = $('html')
$body = $('body')
$window = $(window)
$general = $('div.general')
$condition = $('div.condition')
$slider = {}
$slider.self = $('div.orbit-container')
unless $slider.self.length == 0
	$slider.active = (-> $slider.self.find('.active') )
	$slider.number = $slider.self.find('.orbit-slide-number')
	$slider.next = $slider.self.find('a.orbit-next')
	$slider.prev = $slider.self.find('a.orbit-prev')

	$body.find('article#content').before($slider.self.detach())

	# functions
	$body.keydown (e)->
	  if e.which == 39 # right arrow
	   	$slider.next.click() 
	  if e.which == 37 # left arrow
	   	$slider.prev.click() 

	$window.resize ->
		$active = $slider.active()
		console.log $slider.self.outerWidth(), $active.find('img').outerWidth()
		if $slider.self.outerWidth() > $active.find('img').outerWidth()
			$slider.number.addClass('dark')
		else
			$slider.number.removeClass('dark')
	.resize()

$(document).ready ->
	$slider.self.find('ul').removeClass 'loading'
