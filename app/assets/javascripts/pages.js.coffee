# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

if $('#featured-box').length > 0
	$('#featured-box').find('.car').click ->
		window.location = $(this).find('a.more-info.button').attr('href')

if $('.show.pages.faq').length > 0
	$list = $('.faq-list')
	$terms = $list.find('> dt')
	$defs = $list.find('> dd')
	$defs.hide()
	$terms.each ->
		$(this).data('definition', $(this).next('dd'))
	$terms.hover ->
		$this = $(this)
		$def = $this.data('definition')
		$this.data('text', $this.html())
		message = if $def.is(':hidden') then 'click to expand' else 'click to hide'
		$this.html($this.html() + '<span class="grey right">'+message+'</span>')
	, ->
		$this = $(this)
		$this.html($this.data('text'))
	$terms.click ->
		$this = $(this)
		$def = $this.data('definition')
		if $def.is(':hidden')
			$def.slideDown()
			$this.find('span').html('click to hide')
		else
			$def.slideUp()
			$this.find('span').html('click to expand')