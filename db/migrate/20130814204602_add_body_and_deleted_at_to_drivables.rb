class AddBodyAndDeletedAtToDrivables < ActiveRecord::Migration
  def change
    add_column :drivables, :body, :text
    add_column :drivables, :deleted_at, :datetime
  end
end
