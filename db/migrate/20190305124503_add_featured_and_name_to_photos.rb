class AddFeaturedAndNameToPhotos < ActiveRecord::Migration[5.2]
  def change
    add_column :photos, :featured, :boolean, default: false
    add_column :photos, :name, :string, default: ''
  end
end
