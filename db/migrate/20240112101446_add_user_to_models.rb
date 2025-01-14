class AddUserToModels < ActiveRecord::Migration[7.2]
  def change
    add_reference :quotations, :user, foreign_key: true
    add_reference :canvasses, :user, foreign_key: true
    add_reference :request_forms, :user, foreign_key: true
    add_reference :purchase_orders, :user, foreign_key: true
    add_reference :projects, :user, foreign_key: true
  end
end 