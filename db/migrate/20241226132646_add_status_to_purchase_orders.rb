class AddStatusToPurchaseOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :purchase_orders, :status, :integer
  end
end
