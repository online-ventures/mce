class AddIndicesToVehicles < ActiveRecord::Migration
  def change
    add_index :vehicles, :make_id
    add_index :vehicles, :model_id
    add_index :vehicles, :warranty_id
    add_index :vehicles, :title_id
    add_index :vehicles, :trans_id
    add_index :vehicles, :ext_color_id
    add_index :vehicles, :int_color_id
    add_index :vehicles, :status_id
    add_index :vehicles, :damage_id
    add_index :vehicles, :paint_id
    add_index :vehicles, :interior_id
    add_index :vehicles, :drivable_id
    add_index :vehicles, :engine_id
    add_index :vehicles, :suspension_id
  end
end
