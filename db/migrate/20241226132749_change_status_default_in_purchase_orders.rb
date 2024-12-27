class ChangeStatusDefaultInPurchaseOrders < ActiveRecord::Migration[7.2]
  def change
    change_column_default :purchase_orders, :status, 0
  end
end
