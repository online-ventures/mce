class CreateVehicleTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :vehicle_types do |t|
      t.string :name
      t.timestamps
    end
    add_column :body_types, :vehicle_type_id, :integer
  end
end
