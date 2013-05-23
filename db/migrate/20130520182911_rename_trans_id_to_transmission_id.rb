class RenameTransIdToTransmissionId < ActiveRecord::Migration
  def change
    rename_column :vehicles, :trans_id, :transmission_id
  end
end
