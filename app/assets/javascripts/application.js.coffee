#= require jquery
#= require jquery_ujs
#= require jquery-ui
#= require foundation
#= require_self
#= require_directory ./application/
#= require_tree .

window.smallWidth = $('meta.foundation-mq-small').css('width')
window.mediumWidth = $('meta.foundation-mq-medium').css('width')
window.largeWidth = $('meta.foundation-mq-large').css('width')

$menu = $('#mobile-menu')

$(document).ready ->
  $menu.val(window.location.pathname)

$menu.on 'blur change', ->
  $this = $(this)
  unless $this.val() is window.location.pathname
    window.location.pathname = $this.val()

$body = $('body')
content_height = 0
$body.children().not('script, .typekit-badge, #container').each ->
  content_height += $(this).outerHeight()
$('body > #container').css('min-height', $(window).height() - content_height)

$(document).foundation('orbit', variable_height: true).foundation()
