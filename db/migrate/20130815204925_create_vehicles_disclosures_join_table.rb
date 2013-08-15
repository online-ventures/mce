class CreateVehiclesDisclosuresJoinTable < ActiveRecord::Migration
  def change
  	create_table :vehicles_disclosures, id: false do |t|
		t.integer :vehicle_id, null: false
		t.integer :disclosure_id, null: false
	end

	add_index :vehicles_disclosures, [:vehicle_id, :disclosure_id]

	intro_disclosure = Disclosure.find_or_initialize_by_id(1)
	if intro_disclosure.new_record?
		intro_disclosure.update_attributes({ name: 'intro' })
	end

	# Every Vehicle gets the intro
	Vehicle.unscoped.find_each {|vehicle| vehicle.disclosures << intro_disclosure }
  end
end
