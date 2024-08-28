class AddSupplierReferenceToProducts < ActiveRecord::Migration[7.2]
  def change
    add_reference :products, :supplier, null: true, foreign_key: true
  end
end
