class ChangeTinDataTypeInClients < ActiveRecord::Migration[7.2]
  def change
    change_column :clients, :tin, :bigint
  end
end
