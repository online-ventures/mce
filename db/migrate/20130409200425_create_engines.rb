class CreateEngines < ActiveRecord::Migration
  def change
    create_table :engines do |t|
      t.string :name
    end
  end
end
