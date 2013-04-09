class RemoveTimestampsFromWarrantiesAndVehiclesFeatures < ActiveRecord::Migration
  def up
    remove_column :warranties, :created_at
    remove_column :warranties, :updated_at
    remove_column :vehicles_features, :created_at
    remove_column :vehicles_features, :updated_at
  end

  def down
    add_column :warranties, :created_at, :datetime
    add_column :warranties, :updated_at, :datetime
    add_column :vehicles_features, :created_at, :datetime
    add_column :vehicles_features, :updated_at, :datetime
  end
end
