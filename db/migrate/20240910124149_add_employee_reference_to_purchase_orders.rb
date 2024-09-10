class AddEmployeeReferenceToPurchaseOrders < ActiveRecord::Migration[7.2]
  def change
    add_reference :purchase_orders, :employee, null: false, foreign_key: true
  end
end
