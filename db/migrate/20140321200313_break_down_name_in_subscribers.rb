class BreakDownNameInSubscribers < ActiveRecord::Migration
  def up
    add_column :subscribers, :first_name, :string
    add_column :subscribers, :last_name, :string
    remove_column :subscribers, :name
  end

  def down
    remove_column :subscribers, :first_name
    remove_column :subscribers, :last_name
    add_column :subscribers, :name, :string
  end
end
