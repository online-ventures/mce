class CreateVehiclesFeatures < ActiveRecord::Migration
  def change
    create_table :vehicles_features, id: false do |t|
      t.references :vehicle
      t.references :feature

      t.timestamps
    end
    add_index :vehicles_features, [:vehicle_id, :feature_id]
  end
end
