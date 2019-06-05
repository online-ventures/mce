class Feature < ApplicationRecord
  include Destroyable
  has_and_belongs_to_many :vehicles, join_table: 'vehicles_features'
  before_create :set_order
  before_destroy :shift_up_orders, :destroyed_order

  validates :name, length: {minimum: 3}

  default_scope { where('"order" > 0').order('"order" asc, "id" asc') }

  def set_order
    self.order = (Feature.maximum(:order) || 0) + 1
  end

  def move_to_order(place)
    shift_up_orders
    shift_down_orders(place)
    self.order = place
    save
  end

  # Move the order of existing rows down (++) to make room for moved row
  def shift_down_orders(place)
    order ||= place
    Feature.update_all('"order" = "order" + 1', '"order" >= '+order.to_s)
  end

  # Move the order of existing rows up (--) to cover the gap of moved row
  def shift_up_orders()
    Feature.update_all('"order" = "order" - 1', '"order" > '+order.to_s)
  end

  def destroyed_order
    update_attributes({ order: self.id - 1000 })
  end
end
