class AddOptInDateToSubscribers < ActiveRecord::Migration
  def change
    add_column :subscribers, :opted_in_at, :timestamp
  end
end
