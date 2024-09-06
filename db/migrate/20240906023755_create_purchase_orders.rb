class CreatePurchaseOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :purchase_orders do |t|
      t.string :uid
      t.string :preparer
      t.integer :terms
      t.decimal :total
      t.decimal :discount
      t.string :requester
      t.string :checker
      t.string :pre_approver
      t.string :approver
      t.references :company, null: false, foreign_key: true
      t.references :supplier, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
