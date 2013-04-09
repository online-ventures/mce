class ChangeEngineInVehicles < ActiveRecord::Migration
  def up
    rename_column :vehicles, :engine, :engine_type
  end

  def down
    rename_column :vehicles, :engine_type, :engine
  end
end
