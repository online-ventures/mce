class CreateBodyTypes < ActiveRecord::Migration
  def change
    add_column :vehicles, :body_type_id, :integer
    create_table :body_types do |t|
      t.string :name

      t.timestamps
    end
    add_index :vehicles, :body_type_id
  end
end
