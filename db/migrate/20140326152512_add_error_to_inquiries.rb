class AddErrorToInquiries < ActiveRecord::Migration
  def change
    add_column :inquiries, :error, :string
  end
end
