class BodyType < ActiveRecord::Base
	acts_as_paranoid
	attr_accessible :name, :body
	has_many :vehicles
	default_scope order(:id)

	def to_s
		name
	end

	def restore
		self.deleted_at = nil
		save!
	end
end
