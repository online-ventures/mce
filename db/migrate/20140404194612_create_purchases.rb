class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.belongs_to :subscriber
      t.belongs_to :vehicle
      t.float :price
      t.float :profit

      t.timestamps
    end
  end
end
