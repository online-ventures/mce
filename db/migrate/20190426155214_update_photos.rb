class UpdatePhotos < ActiveRecord::Migration[5.2]
  def change
    remove_column :photos, :image_file_name
    remove_column :photos, :image_content_type
    remove_column :photos, :image_file_size
    remove_column :photos, :image_updated_at
    remove_column :photos, :vehicle_string
    add_column :photos, :uploaded, :boolean, default: false
  end
end
