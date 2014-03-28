class AddSourceToSubscribers < ActiveRecord::Migration
  def change
    add_column :subscribers, :source, :string
  end
end
