class RemoveActiveFromPhotosAndVehicles < ActiveRecord::Migration
  def up
    remove_column :photos, :active
    remove_column :vehicles, :active
  end

  def down
    add_column :photos, :active, :boolean
    add_column :vehicles, :active, :boolean
  end
end
