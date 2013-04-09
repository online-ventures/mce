class CreateDrivables < ActiveRecord::Migration
  def change
    create_table :drivables do |t|
      t.string :name
    end
  end
end
