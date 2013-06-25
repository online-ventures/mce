require 'mandrill'
class SubscriberMailer < ActionMailer::Base
  def self.mandrill
    @mandrill = Mandrill::API.new 'qR-rkGT9xM24xFmeA9qAZA'
  end
  def self.confirm_subscription(subscriber)
    #begin
      mandrill
      template_content = []
      message = {
          from_email: 'noreply@motorcarexport.com',
          from_name: 'Motor Car Export',
          to: [{ email: subscriber.email }],
          headers: { 'Reply-To' => 'noreply@motorcarexport.com' },
          global_merge_vars: [
              {name: 'confirm_link', content: "#{BASEURL}subscriber/#{subscriber.id}/confirm/#{subscriber.confirmation_code}" },
              {name: 'cancel_link', content: "#{BASEURL}subscriber/#{subscriber.id}/cancel/#{subscriber.email}"},
              {name: 'email', content: subscriber.email }
          ]
      }
      response = @mandrill.messages.send_template('subscription-confirmation', template_content, message)
      logger.info response.to_yaml
      #@subscriber = subscriber
      #mail(to: @subscriber.email, subject: 'Thanks for signing up for more info!')
    #rescue Mandrill::Error => e
      #puts "Mandrill Error: #{e.class}: #{e.message}"
    #end
  end
end
