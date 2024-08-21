class CreateQuotations < ActiveRecord::Migration[7.2]
  def change
    create_table :quotations do |t|
      t.string :uid
      t.references :client, null: false, foreign_key: true
      t.string :attention
      t.string :vessel
      t.string :subject
      t.text :remarks
      t.string :payment
      t.text :lead_time
      t.text :warranty
      t.decimal :sub_total
      t.decimal :total
      t.decimal :vat
      t.text :additional_conditions
      t.string :preparer
      t.string :approver

      t.timestamps
    end
  end
end
