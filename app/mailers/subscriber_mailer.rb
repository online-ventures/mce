require 'mandrill'
require 'rdiscount'
class SubscriberMailer < ActionMailer::Base
  include Rails.application.routes.url_helpers

  default from: '"Motor Car Export" <mce@motorcarexport.com>'
  default to: '"Motor Car Export" <mce@motorcarexport.com>'

  def mandrill
    Mandrill::API.new Rails.configuration.mandrill[:api_key]
  end

  def prepare_template_vars(data, subscriber)
    data[:CANCEL_LINK] = cancel_subscribers_url(subscriber.token)
    data[:SUBSCRIBED] = subscriber.subscribed?
    formatted = []
    data.each do |key, value| 
      formatted.push({ name: key.to_s.upcase().sub(' ','_'), content: value })
    end
    formatted
  end

  def prepare_api_data(data)
    unless data[:from_email]
      data[:from_email] = 'mce@motorcarexport.com'
      data[:from_name] = 'Motor Car Export'
    end
    data[:auto_text] = true
    data[:track_opens] = Rails.env.production?
    data[:track_clicks] = Rails.env.production?
    data[:subaccount] = 'motorcarexport'
    data
  end

  def send_inquiry(message)
    template = 'mce-general-inquiry'
    data = prepare_api_data({
      subject: "Vehicle lead for #{message.vehicle.to_s}",  
      from_name: message.subscriber.name,
      from_email: message.subscriber.email,
      to: [{
          email: Rails.env.production? ? 'mce@motorcarexport.com' : 'nick@gronows.com',
          name: Rails.env.production? ? 'Motor Car Export' : 'Nick Gronow'
      }],
      global_merge_vars: prepare_template_vars({
        vehicle_title: message.vehicle.to_s,
        subscriber_link: subscriber_url(message.subscriber),
        name: message.subscriber.name,
        phone: message.subscriber.phone.strip,
        vehicle_link: vehicle_url(message.vehicle),
        vehicle_main_image: vehicle.featured_url,
        body: RDiscount.new(message.body).to_html
      }, message.subscriber)
    })
    async = false
    result = mandrill.messages.send_template template, [], data, async
  rescue Mandrill::Error => e
    message.subscriber.email_errors = e.message
    message.error = e.message
    message.save
  end

  def send_inquiry_confirmation(message)
    template = 'general-inquiry-confirmation'
    data = prepare_api_data({
      subject: "We Received Your Inquiry",  
      to: [{
          email: message.subscriber.email,
          name: message.subscriber.name
      }],
      global_merge_vars: prepare_template_vars({
        name: message.subscriber.name,
        vehicle_title: message.vehicle.to_s,
        vehicle_link: vehicle_url(message.vehicle),
        subscribe_daily: change_plan_subscribers_url('daily', message.subscriber.token),
        subscribe_weekly: change_plan_subscribers_url('weekly', message.subscriber.token)
      }, message.subscriber),
    })
    async = false
    result = mandrill.messages.send_template template, [], data, async
  rescue Mandrill::Error => e
    message.subscriber.email_errors = e.message
    message.error = e.message
    message.save
  end
end
