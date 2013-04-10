class AddDeletedAtToVehicles < ActiveRecord::Migration
  def change
    add_column :vehicles, :deleted_at, :datetime
  end
end
