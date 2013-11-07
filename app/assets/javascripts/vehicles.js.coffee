# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$('.new.banner').each ->
	$this = $(this)
	expr = parseInt($this.attr('data-expires'))
	time = Math.round (new Date()).getTime() / 1000
	if time > expr
		$this.hide()

$('.vehicle').each ->
	$this = $(this)
	href = $this.find('a.expand.radius.button').attr('href')
	if href
		$this.click ->
			window.location = href
