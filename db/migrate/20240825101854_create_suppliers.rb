class CreateSuppliers < ActiveRecord::Migration[7.2]
  def change
    create_table :suppliers do |t|
      t.string :name
      t.string :code
      t.string :contacts
      t.text :address
      t.string :tin
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
