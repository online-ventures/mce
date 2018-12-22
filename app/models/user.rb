class User < ApplicationRecord
  acts_as_authentic do |config|
    config.require_password_confirmation = false
    config.validates_uniqueness_of_login_field_options[:case_sensitive] = true
    config.validates_uniqueness_of_email_field_options[:case_sensitive] = false
  end

  scope :online, -> { where("last_request_at > ?", 10.minutes.ago) }
  scope :active, -> { where("deleted_at IS NULL") }
  scope :inactive, -> { where("deleted_at IS NOT NULL") }


  def to_s
    "#{login}"
  end

  def deactivate
    self.deleted_at = Time.now
    save
  end

  def reactivate
    self.deleted_at = nil
    save
  end
end
