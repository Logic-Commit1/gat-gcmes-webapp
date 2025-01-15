class AddApprovedAtToPurchaseOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :purchase_orders, :approved_at, :datetime
  end
end

