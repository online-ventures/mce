class AddVehiclesPhotoIdToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :vehicles_photo_id, :integer
  end
end
