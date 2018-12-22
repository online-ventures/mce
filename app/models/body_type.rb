class BodyType < ApplicationRecord
  acts_as_paranoid
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
