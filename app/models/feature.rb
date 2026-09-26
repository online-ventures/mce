class Feature < ApplicationRecord
  include Destroyable
  has_and_belongs_to_many :vehicles, join_table: 'vehicles_features'
  before_create :set_order

  validates :name, length: { minimum: 3 }

  default_scope { where('"order" > 0').order('"order" asc, "id" asc') }

  def set_order
    self.order = (Feature.maximum(:order) || 0) + 1
  end
end
