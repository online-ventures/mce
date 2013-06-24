require 'mandrill'
class SubscriberMailer
  def mandrill
    @mandrill = Mandrill::API.new 'qR-rkGT9xM24xFmeA9qAZA'
  end
  def confirm_subscription(subscriber)
    #begin
      mandrill
      template_data = [
          { name: 'confirm-link', content: confirm_subscriber_url(subscriber, subscriber.confirmation_code) }
      ]
      @mandrill.messages.send_template('subscription-confirmation', template_data, {})
      @subscriber = subscriber
      #mail(to: @subscriber.email, subject: 'Thanks for signing up for more info!')
    #rescue Mandrill::Error => e
      #puts "Mandrill Error: #{e.class}: #{e.message}"
    #end
  end
end
