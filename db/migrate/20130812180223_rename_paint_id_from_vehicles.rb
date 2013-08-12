class RenamePaintIdFromVehicles < ActiveRecord::Migration
  def change
    rename_column :vehicles, :paint_id, :exterior_id
  end
end
