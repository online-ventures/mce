$(document).ready ->

  # Determine the environment
  url = window.location.href.split '/'
  host = url[2]
  window.environment = 'development'
  if host.indexOf('dev') == -1
    window.environment = 'production'

  # Only do this in production
  if window.environment == 'production'

    # Register important properties
    #mixpanel.register

    # Links
    mixpanel.track_link '.nav-link', 'Navigation link',
      link: $(this).html()

    mixpanel.track_link '#call-phone', 'Top nav phone',
      referrer: document.referrer

    mixpanel.track_link '#mobile-phone-number', 'Mobile phone call'
    mixpanel.track_link '#desktop-phone-number', 'Desktop phone call'

    mixpanel.track_link '#featured-details-link', 'Featured vehicle link',
      stock: $('#featured-car').attr('data-stock-number')
      name: $('#featured-car').attr('data-name')
      referrer: document.referrer

    mixpanel.track_link '[data-inventory-list-link]', 'Inventory list link',
      stock: $(this).attr('data-stock-number')
      name: $(this).attr('data-name')
