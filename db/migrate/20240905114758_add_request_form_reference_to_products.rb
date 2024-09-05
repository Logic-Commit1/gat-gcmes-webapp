class AddRequestFormReferenceToProducts < ActiveRecord::Migration[7.2]
  def change
    add_reference :products, :request_form, null: true, foreign_key: true
  end
end
