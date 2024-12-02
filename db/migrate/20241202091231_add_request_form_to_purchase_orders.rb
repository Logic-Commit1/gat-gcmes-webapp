class AddRequestFormToPurchaseOrders < ActiveRecord::Migration[7.2]
  def change
    add_reference :purchase_orders, :request_form, null: true, foreign_key: true
  end
end
