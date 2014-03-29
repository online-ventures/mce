require 'digest/sha1'

class Subscriber < ActiveRecord::Base
  acts_as_paranoid
  attr_accessible :first_name, :last_name, :email, :phone, :token, :confirmed?, :subscription_plan, :opted_in_at, :source

  has_many :interests
  has_many :vehicles, through: :interests
  has_many :inquiries

  before_create :create_token
  before_create :default_plan!
  #after_save :send_confirmation

  scope :confirmed, where(confirmed: true)

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, format: { with: %r{.+@.+\..+} }

  def self.find_or_initialize_by_params(params)
    s = (find_by_email(params[:email]) or self.new)
    s.attributes = params
    s
  end

  def to_s
    name
  end

  def name
    "#{first_name} #{last_name}"
  end

  def email_format
    "\"#{name}\" <#{email}>"
  end

  def subscribed?
    subscription_plan.present?
  end

  def subscribed!
    self.plan = 'weekly'
    opted_in
  end

  def cancel!
    self.plan = 'none'
  end

  def plan
    "#{subscription_plan} subscriber" if subscription_plan.present?
    "no subscription plan"
  end

  def plan=(new_plan)
    if ['weekly','daily','none'].include? new_plan
      new_plan = '' if new_plan == 'none'
      self.subscription_plan = new_plan
      opted_in
      save
      true
    else
      false
    end
  end

  def opt_in_date
    opted_in_at.to_formatted_s(:short) if opted_in_at.present?
    "Never opted in"
  end

  def source_text
    source if source.present?
    "none"
  end

  def interested_in(vehicle_id)
    interests.where(vehicle_id: vehicle_id).first
  end

  def save_interest(params)
    @interest = Interest.where(subscriber_id: id, vehicle_id: params[:vehicle_id]).first
    if @interest
      @interest.update_attributes params
    else
      @interest = interests.create params
    end
    @interest
  end

  def search_results
    { first_name: first_name, last_name: last_name, email: email, phone: phone }
  end

  private

    def create_token
      self.token = Digest::SHA1.hexdigest("#{id} - #{email}")
      self.confirmed = false
      true
    end

    def default_plan!
      self.subscription_plan = ''
    end

    def opted_in
      if opted_in_at.blank?
        self.opted_in_at = DateTime.now
      end
    end

    def send_confirmation
      unless confirmed? || (!!sent_at and sent_at > 3.minutes.ago)
        self.sent_at = Time.now
        SubscriberMailer.confirm_subscription(self)
      end
    end
end
