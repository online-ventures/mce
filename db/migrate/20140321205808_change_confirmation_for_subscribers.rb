class ChangeConfirmationForSubscribers < ActiveRecord::Migration
  def up
    rename_column :subscribers, :confirmation_code, :token
  end

  def down
    rename_column :subscribers, :token, :confirmation_code
  end
end
