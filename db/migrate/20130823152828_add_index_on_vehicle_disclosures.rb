class AddIndexOnVehicleDisclosures < ActiveRecord::Migration
  def up
    remove_index :vehicles_disclosures, name: 'index_vehicles_disclosures_on_vehicle_id_and_disclosure_id'
    add_index :vehicles_disclosures, [:vehicle_id, :disclosure_id], unique: true, name: 'index_vehicles_disclosures_on_vehicle_id_and_disclosure_id'
  end

  def down
    remove_index :vehicles_disclosures, name: 'index_vehicles_disclosures_on_vehicle_id_and_disclosure_id'
    add_index :vehicles_disclosures, [:vehicle_id, :disclosure_id], 'index_vehicles_disclosures_on_vehicle_id_and_disclosure_id'
  end
end
