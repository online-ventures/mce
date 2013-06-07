class AddDefaultsToVariousFields < ActiveRecord::Migration
  def change
    change_column :vehicles, :featured, :boolean, default: false
    change_column :vehicles, :sold, :boolean, default: false
    change_column :vehicles, :tears, :boolean, default: false
    change_column :vehicles, :stains, :boolean, default: false
    change_column :vehicles, :burns, :boolean, default: false
  end
end
