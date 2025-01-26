class CreateDocumentSequences < ActiveRecord::Migration[7.2]
  def change
    create_table :document_sequences do |t|
      t.string :document_type
      t.string :company_code
      t.integer :last_sequence
      t.integer :year

      t.timestamps
    end

    add_index :document_sequences, [:document_type, :company_code, :year], unique: true, name: 'unique_document_sequence'
  end
end 