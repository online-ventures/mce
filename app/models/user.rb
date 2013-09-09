class User < ActiveRecord::Base
	acts_as_authentic do |config|
		config.require_password_confirmation = false
		config.validates_uniqueness_of_login_field_options[:case_sensitive] = true
		config.validates_uniqueness_of_email_field_options[:case_sensitive] = false
	end

	attr_accessible :crypted_password, :current_login_at, :current_login_ip, :email, :failed_login_count,
					:last_login_at, :last_login_ip, :last_request_at, :login, :login_count, :password,
					:password_salt, :perishable_token, :persistence_token, :username, :password

	scope :online, where("last_request_at > ?", 10.minutes.ago)
	scope :active, where("deleted_at IS NULL")
	scope :inactive, where("deleted_at IS NOT NULL")


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
