class CreateCanvasses < ActiveRecord::Migration[7.2]
  def change
    create_table :canvasses do |t|
      t.string :uid
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
