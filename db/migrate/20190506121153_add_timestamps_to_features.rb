class AddTimestampsToFeatures < ActiveRecord::Migration[5.2]
  def up
    add_column :features, :created_at, :datetime, null: true
    add_column :features, :updated_at, :datetime, null: true

    Feature.unscoped.update_all(created_at: 1.week.ago, updated_at: 1.week.ago)

    change_column :features, :created_at, :datetime, null: false
    change_column :features, :updated_at, :datetime, null: false
  end

  def down
    remove_column :features, :created_at
    remove_column :features, :updated_at
  end
end
