class RemoveCanvassIdFromSuppliers < ActiveRecord::Migration[7.2]
  def change
    remove_column :suppliers, :canvass_id
  end
end
