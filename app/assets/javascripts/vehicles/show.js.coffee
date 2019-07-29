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
    if $slider.self.outerWidth() > $active.find('img').outerWidth()
      $slider.number.addClass('dark')
    else
      $slider.number.removeClass('dark')
  .resize()

$(document).ready ->
  $slider.self.find('ul').removeClass('loading')
  contactForm = new AjaxifyModal 'email-form', 'new_inquiry'
  subscribeForm = new AjaxifyModal 'subscribe-form', 'new_subscriber'
  $('#email-form #subscriber_email').blur ->
    return if $(this).val() == ''
    contactForm.show_loading()
    $.ajax(
      url: "/subscribers/search"
      data: {email: $(this).val()}
      dataType: 'json'
      success: (data) ->
        $('#email-form #subscriber_first_name').val data.first_name
        $('#email-form #subscriber_last_name').val data.last_name
        $('#email-form #subscriber_phone').val data.phone
      complete: ->
        contactForm.show_form()
        $('#email-form #subscriber_first_name').focus()
    )
  $('#subscribe-form #subscriber_email').blur ->
    return if $(this).val() == ''
    subscribeForm.show_loading()
    $.ajax(
      url: "/subscribers/search"
      data: {email: $(this).val()}
      dataType: 'json'
      success: (data) ->
        $('#subscribe-form #subscriber_first_name').val data.first_name
        $('#subscribe-form #subscriber_last_name').val data.last_name
        $('#subscribe-form #subscriber_phone').val data.phone
      complete: ->
        subscribeForm.show_form()
        $('#subscribe-form #subscriber_first_name').focus()
    )
