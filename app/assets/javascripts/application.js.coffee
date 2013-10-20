#= require jquery
#= require jquery_ujs
#= require jquery.ui.all
#= require foundation
#= require jquery.form
#= require html5shiv
#= require respond.min
#= require_self
#= require_directory ./application/
#= require_tree .

$(window).resize ->
	$this = $(this)
	topbars = $('body > .topbar')
	$topbar = $(topbars[0])
	$subnav = $(topbars[1])

	min_width = 0
	$topbar.find('h1,img').map ->
		min_width += $(this).outerWidth()
	if $this.outerWidth() < min_width
		$topbar.css 'min-height', ($topbar.find('h1').outerHeight() * 2) + 'px'
		$topbar.find('h1').removeClass('right').addClass('center')
	else
		$topbar.css 'min-height', $topbar.find('h1').outerHeight() + 'px'
		$topbar.find('h1').removeClass('center')
		$topbar.find('h1').last().addClass('right')
	if $subnav.outerHeight() >= $subnav.find('li').outerHeight() * 2
		$subnav.find('li').map ->
			if $(this).html().search(/about|buyer/) > 1
				$(this).hide()
$body = $('body')
content_height = 0
$body.children().not('script, .typekit-badge, #container').each ->
	content_height += $(this).outerHeight()
$('body > #container').css('min-height', $(window).height() - content_height)

$(document).foundation()
