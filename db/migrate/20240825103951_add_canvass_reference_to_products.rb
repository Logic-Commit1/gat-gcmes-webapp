class AddCanvassReferenceToProducts < ActiveRecord::Migration[7.2]
  def change
    add_reference :products, :canvass, null: true, foreign_key: true
  end
end
