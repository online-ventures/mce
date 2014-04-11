class AddSourceToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :source, :string
  end
end
