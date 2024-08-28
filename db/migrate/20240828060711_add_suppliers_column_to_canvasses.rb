class AddSuppliersColumnToCanvasses < ActiveRecord::Migration[7.2]
  def change
    add_column :canvasses, :suppliers, :jsonb, default: []
  end
end
