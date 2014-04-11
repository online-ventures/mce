class AddIndexToSubscribersVehicles < ActiveRecord::Migration
  def change
    add_index(:subscribers_vehicles, [:subscriber_id, :vehicle_id], :unique => true)
  end
end
