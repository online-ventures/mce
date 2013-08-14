class AddBodyAndDeletedAtToWarranties < ActiveRecord::Migration
  def change
    add_column :warranties, :body, :text
    add_column :warranties, :deleted_at, :datetime
  end
end
