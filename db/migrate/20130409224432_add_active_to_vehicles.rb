class AddActiveToVehicles < ActiveRecord::Migration
  def change
    add_column :vehicles, :active, :boolean
  end
end
