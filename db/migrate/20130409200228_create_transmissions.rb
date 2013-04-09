class CreateTransmissions < ActiveRecord::Migration
  def change
    create_table :transmissions do |t|
      t.string :name
    end
  end
end
