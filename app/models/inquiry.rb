class Inquiry < ActiveRecord::Base
  attr_accessible :body, :subscriber_id, :vehicle_id, :error

  # Relationships
  belongs_to :subscriber
  belongs_to :vehicle

  # Validations
  validates :body, presence: true

  # Callbacks
  after_create :send_emails

  def vehicle
    Vehicle.unscoped { super }
  end

  def no_error?
    error == ''
  end

  def send_emails
    SubscriberMailer.send_inquiry self
    SubscriberMailer.send_inquiry_confirmation self
  end
end
