class CreateClients < ActiveRecord::Migration[7.2]
  def change
    create_table :clients do |t|
      t.string :name
      t.string :code
      t.string :contacts
      t.text :address
      t.string :partner
      t.integer :tin

      t.timestamps
    end
  end
end
