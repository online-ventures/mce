class AddUniqueIndexToInterests < ActiveRecord::Migration
  def change
    add_index :interests, [:subscriber_id, :vehicle_id], unique: true
  end
end
