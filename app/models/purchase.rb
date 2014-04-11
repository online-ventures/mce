class Purchase < ActiveRecord::Base
  attr_accessible :price, :profit, :subscriber_id, :vehicle_id, :source

  belongs_to :subscriber
  belongs_to :vehicle

  validates :price, presence: true, numericality: true
  validates :profit, numericality: true, if: :profit?
end
