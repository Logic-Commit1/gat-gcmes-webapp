class CreateRequestFormSequences < ActiveRecord::Migration[7.2]
  def change
    create_table :request_form_sequences do |t|
      t.string :request_type
      t.integer :last_sequence

      t.timestamps
    end
  end
end
