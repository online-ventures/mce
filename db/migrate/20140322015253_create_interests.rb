class CreateInterests < ActiveRecord::Migration
  def change
    create_table :interests do |t|
      t.integer :subscriber_id
      t.integer :vehicle_id
      t.timestamp :purchased_at
      t.float :purchase_price

      t.timestamps
    end
  end
end
