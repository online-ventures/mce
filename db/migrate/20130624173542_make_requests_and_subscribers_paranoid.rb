class MakeRequestsAndSubscribersParanoid < ActiveRecord::Migration
  def change
    add_column :requests, :deleted_at, :datetime
    add_column :subscribers, :deleted_at, :datetime
  end
end
