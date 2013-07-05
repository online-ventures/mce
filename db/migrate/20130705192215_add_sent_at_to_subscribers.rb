class AddSentAtToSubscribers < ActiveRecord::Migration
  def change
    add_column :subscribers, :sent_at, :datetime
  end
end
