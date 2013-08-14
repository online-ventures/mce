class CreateDisclosures < ActiveRecord::Migration
  def change
    create_table :disclosures do |t|
      t.string :name
      t.text :body
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
