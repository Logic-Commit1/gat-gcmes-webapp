class CreateCompanies < ActiveRecord::Migration[7.2]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :code
      t.text :address
      t.bigint :tin

      t.timestamps
    end
  end
end
