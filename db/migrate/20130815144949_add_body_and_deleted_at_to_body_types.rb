class AddBodyAndDeletedAtToBodyTypes < ActiveRecord::Migration
  def change
    add_column :body_types, :body, :text
    add_column :body_types, :deleted_at, :datetime
  end
end
