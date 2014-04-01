class Interest < ActiveRecord::Base
  attr_accessible :purchase_price, :purchased_at, :subscriber_id, :vehicle_id

  #Relationships
  belongs_to :vehicle
  belongs_to :subscriber
end
