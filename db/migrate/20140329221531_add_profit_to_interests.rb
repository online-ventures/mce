class AddProfitToInterests < ActiveRecord::Migration
  def change
    add_column :interests, :profit, :float
  end
end
