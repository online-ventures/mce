class AddConfimationFieldsToSubscribers < ActiveRecord::Migration
  def change
    add_column :subscribers, :confirmation_code, :string
    add_column :subscribers, :confirmed, :boolean
  end
end
