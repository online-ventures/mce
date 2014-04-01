class AddEmailErrorsToSubscribers < ActiveRecord::Migration
  def change
    add_column :subscribers, :email_errors, :string, default: ''
  end
end
