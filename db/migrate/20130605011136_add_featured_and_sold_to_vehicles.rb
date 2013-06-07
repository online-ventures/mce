class AddFeaturedAndSoldToVehicles < ActiveRecord::Migration
  def change
    add_column :vehicles, :featured, :boolean
    add_column :vehicles, :sold, :boolean
  end
end
