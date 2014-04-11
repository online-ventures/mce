$(document).ready ->

  # jQuery extensions
  $.fn.exists = ->
    @length != 0

  $.urlParam = (name) ->
    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]")
    regex = new RegExp("[\\?&]" + name + "=([^&#]*)")
    results = regex.exec(location.search)
    if results then decodeURIComponent results[1].replace(/\+/g, " ") else ""

  # Global register data
  register_data = {}

  # Subscriber data
  register_data = window.subscriber if window.subscriber

  # Specified source
  if $.urlParam('mps')
    register_data.source = $.urlParam('mps')
  else if $.cookie('msp')
    register_data.source = $.cookie('mps')

  # Vehicle details
  $.extend register_data, $.parseJSON($('#vehicle-data').attr('data-vehicle')) if $('#vehicle-data').exists()

  # Register the data
  mixpanel.register register_data

  # Unique subscribers please
  mixpanel.identify = window.subscriber_id if window.subscriber_id

  # Featured vehicle
  window.featured = $.parseJSON $('#featured-car').attr('data-vehicle') if $('#featured-car').exists()

  # Links
  $('a[data-mixpanel]').each ->
    $(this).uniqueId()
    properties = {} # defaults can go here
    $.extend properties, $.parseJSON($(this).attr('data-properties')) if $(this).attr('data-properties')
    mixpanel.track_links '#'+this.id, $(this).attr('data-mixpanel'), properties

  #mixpanel.track_link '#call-phone', 'Top nav phone',
    #referrer: document.referrer

  #mixpanel.track_link '#mobile-phone-number', 'Mobile phone call'
  #mixpanel.track_link '#desktop-phone-number', 'Desktop phone call'

  #mixpanel.track_link '#featured-details-link', 'Featured vehicle link',
    #stock: $('#featured-car').attr('data-stock-number')
    #name: $('#featured-car').attr('data-name')
    #referrer: document.referrer

  #mixpanel.track_link '[data-inventory-list-link]', 'Inventory list link',
    #stock: $(this).attr('data-stock-number')
    #name: $(this).attr('data-name')
