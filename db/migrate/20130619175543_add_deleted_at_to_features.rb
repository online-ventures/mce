class AddDeletedAtToFeatures < ActiveRecord::Migration
  def change
    add_column :features, :deleted_at, :datetime
  end
end
