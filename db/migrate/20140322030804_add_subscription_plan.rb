class AddSubscriptionPlan < ActiveRecord::Migration
  def up
    add_column :subscribers, :subscription_plan, :string
  end

  def down
    remove_column :subscribers, :subscription_plan
  end
end
