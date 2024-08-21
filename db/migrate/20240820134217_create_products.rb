class CreateProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :products do |t|
      t.string :name
      t.integer :quantity
      t.string :unit
      t.decimal :price
      t.string :brand
      t.text :description
      t.text :specs
      t.text :terms
      t.text :remarks
      t.string :image
      t.references :quotation, foreign_key: true
      # t.references :canvass, foreign_key: true
      # t.references :request_form, foreign_key: true
      # t.references :purchase_order, foreign_key: true

      t.timestamps
    end
  end
end
