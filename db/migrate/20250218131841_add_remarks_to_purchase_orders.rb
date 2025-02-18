class AddRemarksToPurchaseOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :purchase_orders, :remarks, :text
  end
end
