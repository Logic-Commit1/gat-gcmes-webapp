class CreateParticulars < ActiveRecord::Migration[7.2]
  def change
    create_table :particulars do |t|
      t.string :name
      t.decimal :allowance
      t.references :request_form, null: false, foreign_key: true

      t.timestamps
    end
  end
end
