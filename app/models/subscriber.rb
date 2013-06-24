require 'digest/sha1'

class Subscriber < ActiveRecord::Base
  acts_as_paranoid
  attr_accessible :email, :name, :phone, :requests, :confirmation_code, :confirmed?
  has_many :requests, dependent: :destroy
  before_create :create_confirmation_code
  after_create :send_confirmation

  scope :confirmed, where(confirmed: true)

  private
  def confirm
    self.confirmation_code = nil
    self.confirmed = true
    save
  end
  def cancel
    self.confirmation_code = nil
    destroy
  end
  def create_confirmation_code
    self.confirmation_code = Digest::SHA1.hexdigest("#{self.id} - #{self.email}")
    self.confirmed = false
  end
  def send_confirmation
    SubscriberMailer.confirm_subscription(self)
  end
end
