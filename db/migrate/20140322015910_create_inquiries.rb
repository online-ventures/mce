class CreateInquiries < ActiveRecord::Migration
  def change
    create_table :inquiries do |t|
      t.integer :subscriber_id
      t.integer :vehicle_id
      t.text :body

      t.timestamps
    end
  end
end
