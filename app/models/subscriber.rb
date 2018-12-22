require 'digest/sha1'

class Subscriber < ApplicationRecord
  acts_as_paranoid

  has_and_belongs_to_many :vehicles, uniq: true
  has_many :inquiries
  has_many :purchases

  before_create :create_token
  before_create :default_plan!
  #after_save :send_confirmation

  scope :confirmed, -> { where(confirmed: true) }

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, format: { with: %r{.+@.+\..+} }, if: :require_email?

  def require_email?
    source != 'buyer form'
  end

  def self.find_or_initialize_by_params(params)
    s = (find_by(email: params[:email]) or self.new)
    if params[:subscription_plan] and s.subscription_plan == 'daily'
      params.delete :subscription_plan
    end
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

  # Source can only be set once
  def source=(new_source)
    unless source
      write_attribute :source, new_source
    end
  end

  def plan
    subscription_plan.present? ? "#{subscription_plan} subscriber" : "no subscription plan"
  end

  def plan=(new_plan)
    if ['monthly','weekly','daily','none'].include? new_plan
      new_plan = '' if new_plan == 'none'
      self.subscription_plan = new_plan
      unless new_plan == ''
        self.opted_in_at = DateTime.now
      end
      save
    end
  end

  def opt_in_date
    opted_in_at.present? ? opted_in_at.to_formatted_s(:short) : "Never opted in"
  end

  def source_text
    source.present? ? source : "none"
  end

  def search_results
    { first_name: first_name, last_name: last_name, email: email, phone: phone }
  end

  def likes(vehicle)
    unless vehicles.where(id: vehicle.id).exists?
      vehicles.push vehicle
    end
  end

  def unlikes(vehicle)
    vehicles.delete vehicle
  end

  def mixpanel_fields
    [:first_name,:last_name,:email,:phone,:source,:subscription_plan]
  end

  def to_mixpanel_hash
    serializable_hash only: mixpanel_fields
  end

  def to_mixpanel_json
    to_json only: mixpanel_fields
  end

  private

    def to_hash(methods)
      hash = {}
      methods.each do |m|
        send m
      end
    end

    def create_token
      self.token = Digest::SHA1.hexdigest("#{id} - #{email}")
      self.confirmed = false
      true
    end

    def default_plan!
      self.subscription_plan = ''
    end

    def send_confirmation
      unless confirmed? || (!!sent_at and sent_at > 3.minutes.ago)
        self.sent_at = Time.now
        SubscriberMailer.confirm_subscription(self)
      end
    end
end
