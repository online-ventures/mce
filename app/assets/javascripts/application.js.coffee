# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# the compiled file.
#
# WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
# GO AFTER THE REQUIRES BELOW.
#
#= require jquery
#= require jquery_ujs
#= require jquery.ui.all
#= require foundation
#= require jquery.form
#= require jquery.nivo.slider
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

	$floater = $subnav.find('.right')
	if $floater.offset()['top'] >= $subnav.offset()['top'] + $subnav.outerHeight()
		$subnav.css 'min-height', $subnav.outerHeight() + $floater.outerHeight() + 'px'

$body = $('body')
content_height = 0
$body.children().not('script, .typekit-badge, #container').each ->
	content_height += $(this).outerHeight()
$('body > #container').css('min-height', $(window).height() - content_height)

$(document).foundation()