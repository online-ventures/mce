class AddIndexToPhotos < ActiveRecord::Migration
  def change
    add_index :photos, :vehicle_id
  end
end
