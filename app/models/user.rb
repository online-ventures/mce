class User < ApplicationRecord
  acts_as_authentic do |config|
    config.require_password_confirmation = false
    config.crypto_provider = Authlogic::CryptoProviders::SCrypt
  end

  scope :online, -> { where('last_request_at > ?', 10.minutes.ago) }
  scope :active, -> { where('deleted_at IS NULL') }
  scope :inactive, -> { where('deleted_at IS NOT NULL') }

  def to_s
    login.to_s
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
