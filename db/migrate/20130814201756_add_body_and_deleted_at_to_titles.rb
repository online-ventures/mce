class AddBodyAndDeletedAtToTitles < ActiveRecord::Migration
  def change
    add_column :titles, :body, :text
    add_column :titles, :deleted_at, :datetime
  end
end
