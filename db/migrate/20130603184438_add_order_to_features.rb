class AddOrderToFeatures < ActiveRecord::Migration
  def change
    add_column :features, :order, :integer
  end
end
