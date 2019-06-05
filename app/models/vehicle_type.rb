class VehicleType < ApplicationRecord
  has_many :body_types

  default_scope { order(:id) }

  def to_s
    name
  end
end
