class RenameConditionTitleToConditionName < ActiveRecord::Migration
  def change
    rename_column :conditions, :title, :name
  end
end
