class MakeUsersParanoid < ActiveRecord::Migration
	def up
  		add_column :users, :deleted_at, :datetime, { null: true, default: nil }
	end
end
