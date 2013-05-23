class AddVehicleIdToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :vehicle_id, :integer
  end
end
