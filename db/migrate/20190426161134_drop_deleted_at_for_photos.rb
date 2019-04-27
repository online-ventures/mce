class DropDeletedAtForPhotos < ActiveRecord::Migration[5.2]
  def change
    remove_column :photos, :deleted_at
  end
end
