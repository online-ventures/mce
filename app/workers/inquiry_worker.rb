class InquiryWorker
  include Sidekiq::Worker

  def perform(inquiry_id)
    MailgunService.send_inquiry_email inquiry_id
  end
end
