class CreateDamages < ActiveRecord::Migration
  def change
    create_table :damages do |t|
      t.string :name
    end
  end
end
