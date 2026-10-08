class Feature < ApplicationRecord
  include Destroyable
  has_and_belongs_to_many :vehicles, join_table: 'vehicles_features'
  before_create :set_order

  validates :name, length: { minimum: 3 }

  default_scope { where('"order" > 0').order('"order" asc, "id" asc') }

  def set_order
    self.order = (Feature.maximum(:order) || 0) + 1
  end

  # Move this feature one place up or down among the live features.
  # Renumbers the whole list (1..n) so gaps/duplicate orders are healed.
  # Returns false if the feature can't move in that direction.
  def move(direction)
    list = Feature.alive.to_a
    index = list.index(self)
    return false unless index

    target = direction.to_s == 'up' ? index - 1 : index + 1
    return false if target.negative? || target >= list.size

    list[index], list[target] = list[target], list[index]
    Feature.transaction do
      list.each_with_index do |feature, i|
        feature.update_column(:order, i + 1) unless feature.order == i + 1
      end
    end
    true
  end
end
