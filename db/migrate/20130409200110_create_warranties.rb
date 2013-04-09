class CreateWarranties < ActiveRecord::Migration
  def change
    create_table :warranties do |t|
      t.string :name

      t.timestamps
    end
  end
end
