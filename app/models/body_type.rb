class BodyType < ApplicationRecord
  include Destroyable

  belongs_to :vehicle_type

  has_many :vehicles
  default_scope { order(:id) }

  def to_s
    name
  end
end
