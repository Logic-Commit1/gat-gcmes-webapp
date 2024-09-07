class RemoveProjectReferenceFromPurchaseOrders < ActiveRecord::Migration[7.2]
  def change
    remove_reference :purchase_orders, :project, foreign_key: true
  end
end
