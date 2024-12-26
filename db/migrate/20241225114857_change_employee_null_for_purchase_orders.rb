class ChangeEmployeeNullForPurchaseOrders < ActiveRecord::Migration[7.2]
  def change
    change_column_null :purchase_orders, :employee_id, true
  end
end
