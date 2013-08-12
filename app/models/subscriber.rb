require 'digest/sha1'

class Subscriber < ActiveRecord::Base
  acts_as_paranoid
  attr_accessible :email, :name, :phone, :requests, :confirmation_code, :confirmed?
  has_many :requests, dependent: :destroy
  before_create :create_confirmation_code
  after_save :send_confirmation

  scope :confirmed, where(confirmed: true)

  validates :email, presence: true


  def to_s
    name || email
  end
  def confirm_link
    confirm_subscriber_url(subscriber: self, code: confirmation_code)
  end
  def cancel_link
    cancel_subscriber_url(subscriber: self, code: email)
  end
  def confirm
    self.confirmed = true
    save
  end
  def cancel
    self.confirmation_code = nil
    destroy
  end

  private
    def create_confirmation_code
      self.confirmation_code = Digest::SHA1.hexdigest("#{self.id} - #{self.email}")
      self.confirmed = false
      true
    end
    def send_confirmation
      unless confirmed? || (!!sent_at and sent_at > 3.minutes.ago)
        self.sent_at = Time.now
        SubscriberMailer.confirm_subscription(self)
      end
    end
end
