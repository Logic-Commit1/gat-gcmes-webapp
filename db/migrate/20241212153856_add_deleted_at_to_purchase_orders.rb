class AddDeletedAtToPurchaseOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :purchase_orders, :deleted_at, :datetime
    add_index :purchase_orders, :deleted_at
  end
end
