class Feature < ActiveRecord::Base
  attr_accessible :name, :order
  has_and_belongs_to_many :vehicles, join_table: 'vehicles_features'
  before_create :set_order
  before_destroy :bump_orders

  default_scope order('"order" asc')

  def toggle_vehicle
    if self.in? @vehicle.features
      @vehicle.features.delete(self)
    else
      @vehicle.features << self
    end
  end

  def move_to_order(place)
    shift_up_orders
    shift_down_orders(place)
    self.order = place
    save
  end

  def set_order
    self.order = (Feature.maximum(:order) || 0) + 1
  end

  def shift_down_orders(place)
    order ||= place
    Feature.update_all('"order" = "order" + 1', '"order" >= '+order.to_s)
    #Feature.where("\"order\" >= ?", order).find_each do |f|
    #  f.order += 1
    #  f.save
    #end
  end

  def shift_up_orders()
    Feature.update_all('"order" = "order" - 1', '"order" > '+order.to_s)
    #Feature.where("\"order\" > ?", self.order).find_each do |f|
    #  f.order -= 1
    #  f.save
    #end
  end
end
