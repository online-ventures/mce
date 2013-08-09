# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$('.vehicle').each ->
  unless $(this).hasClass('new')
    $('i.foundicon-smiley.new').hide(); # Hide the new status instead of rendering differently