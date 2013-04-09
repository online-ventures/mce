class RemovePaintAndInteriorTables < ActiveRecord::Migration
  def up
    drop_table :interiors
    drop_table :paints
  end

  def down
    create_table "interiors", :force => true do |t|
      t.string "name"
    end
    create_table "paints", :force => true do |t|
      t.string "name"
    end
  end
end
