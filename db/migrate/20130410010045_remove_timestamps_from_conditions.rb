class RemoveTimestampsFromConditions < ActiveRecord::Migration
  def up
    remove_column :conditions, :created_at
    remove_column :conditions, :updated_at
  end

  def down
    add_column :conditions, :created_at, :datetime
    add_column :conditions, :updated_at, :datetime
  end
end
