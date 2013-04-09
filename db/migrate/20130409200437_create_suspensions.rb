class CreateSuspensions < ActiveRecord::Migration
  def change
    create_table :suspensions do |t|
      t.string :name
    end
  end
end
