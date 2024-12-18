class CreateSpecs < ActiveRecord::Migration[7.2]
  def change
    create_table :specs do |t|
      t.string :name, null: false
      t.string :value, null: false
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
