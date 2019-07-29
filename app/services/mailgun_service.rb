class MailgunService
  class << self
    def send_inquiry_email(inquiry_id)
      raise 'Recipient not set' unless recipient
      inquiry = Inquiry.find inquiry_id
      data = {
        vehicle: inquiry.vehicle,
        inquirer: inquiry.subscriber,
        body: inquiry.body
      }
      html = render_html(template: 'inquiry', data: data)
      message = build_message(data, html)
      send_message message, inquiry
    end

    def send_message(message, inquiry)
      response = client.send_message(domain, message)
      inquiry.update(error: response.to_h['message'])
      Rails.logger.info "Sent an email to Mailgun.  Received code: #{response.code}"
      raise 'Mailgun failed to queue message' unless response.code.between?(200, 299)
    end

    def build_message(data, html)
      msg = Mailgun::MessageBuilder.new
      msg.from 'support@motorcarexport.com', 'full_name' => 'Motor Car Export'
      msg.reply_to data[:inquirer].email, 'full_name' => data[:inquirer].name
      msg.subject "Vehicle lead for #{data[:vehicle].to_s}"
      msg.add_recipient(:to, recipient)
      msg.body_html html
      msg
    end

    def convert_text_to_html(text)
      text.gsub("\n", '<br>').html_safe
    end

    def render_html(template:, data: {})
      ApplicationController.render(
        "emails/#{template}",
        assigns: data,
        layout: false
      )
    end

    def recipient
      Rails.application.credentials.recipient[Rails.env.to_sym]
    end

    def client
      @@client ||= Mailgun::Client.new api_key
    end

    def api_key
      mailgun_secrets[:key]
    end

    def domain
      mailgun_secrets[:domain]
    end

    def mailgun_secrets
      Rails.application.credentials.mailgun[:production]
    end
  end
end
