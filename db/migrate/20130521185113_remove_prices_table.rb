class RemovePricesTable < ActiveRecord::Migration
  def up
    drop_table :prices
  end

  def down
    create_table :price do |t|
      t.string :amount
    end
  end
end
