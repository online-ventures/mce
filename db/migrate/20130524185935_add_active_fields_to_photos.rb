class AddActiveFieldsToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :active, :boolean, default: true
    add_column :photos, :deleted_at, :datetime
  end
end
