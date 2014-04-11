class DropBuyerInfoFromInterests < ActiveRecord::Migration
  def up
    drop_table :interests
    create_table :subscribers_vehicles, id: false do |t|
      t.belongs_to :subscriber
      t.belongs_to :vehicle
    end
  end

  def down
    drop_table :subscribers_vehicles
    create_table "interests", :force => true do |t|
      t.integer  "subscriber_id"
      t.integer  "vehicle_id"
      t.datetime "purchased_at"
      t.float    "purchase_price"
      t.datetime "created_at",     :null => false
      t.datetime "updated_at",     :null => false
      t.float    "profit"
    end
  end
end
