class CreateVehicles < ActiveRecord::Migration
  def change
    create_table :vehicles do |t|
      t.integer :year
      t.integer :make_id
      t.integer :model_id
      t.string :subtitle
      t.string :ebay
      t.string :stock_number
      t.string :vin
      t.integer :warranty_id
      t.integer :title_id
      t.string :engine
      t.integer :trans_id
      t.integer :miles
      t.integer :ext_color_id
      t.integer :int_color_id
      t.integer :status_id
      t.integer :price
      t.integer :damage_id
      t.integer :paint_id
      t.integer :interior_id
      t.integer :drivable_id
      t.integer :engine_id
      t.integer :suspension_id
      t.boolean :stains
      t.boolean :burns
      t.boolean :tears
      t.text :description

      t.timestamps
    end
  end
end
