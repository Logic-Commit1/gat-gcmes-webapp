class AddApproverReferencesToCanvassesRequestFormsPurchaseOrders < ActiveRecord::Migration[7.2]
  def change
    add_reference :canvasses, :approver, null: true, foreign_key: { to_table: :users }
    add_reference :request_forms, :approver, null: true, foreign_key: { to_table: :users }
    add_reference :purchase_orders, :approver, null: true, foreign_key: { to_table: :users }
  end
end
