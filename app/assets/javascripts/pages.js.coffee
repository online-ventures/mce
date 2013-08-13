# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

if $('#featured-box').length > 0
  $('#featured-box').find('.car').click ->
    window.location = $(this).find('a.more-info.button').attr('href')