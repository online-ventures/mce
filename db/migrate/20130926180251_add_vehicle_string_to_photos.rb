class AddVehicleStringToPhotos < ActiveRecord::Migration
  def change
  	add_column :photos, :vehicle_string, :string, default: nil
  end
end
