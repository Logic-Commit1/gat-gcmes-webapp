class AddProjectToPurchaseOrders < ActiveRecord::Migration[7.2]
  def change
    add_reference :purchase_orders, :project, null: false, foreign_key: true
  end
end
