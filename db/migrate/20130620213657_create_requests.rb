class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.integer :subscriber_id
      t.integer :vehicle_id
      t.integer :body_type_id

      t.timestamps
    end
    add_index :requests, :subscriber_id
    add_index :requests, :vehicle_id
    add_index :requests, :body_type_id
  end
end
