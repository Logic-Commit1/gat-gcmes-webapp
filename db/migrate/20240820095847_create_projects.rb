class CreateProjects < ActiveRecord::Migration[7.2]
  def change
    create_table :projects do |t|
      t.string :uid
      t.references :client, null: false, foreign_key: true
      t.integer :status
      t.decimal :amount
      t.integer :payment

      t.timestamps
    end
  end
end
