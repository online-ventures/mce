class AddIndexForModels < ActiveRecord::Migration
  def up
    add_index :models, :make_id
  end

  def down
    remove_index :models, :make_id
  end
end
