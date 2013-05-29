class AddFeaturedIdToVehicle < ActiveRecord::Migration
  def change
    add_column :vehicles, :featured_id, :integer
  end
end
