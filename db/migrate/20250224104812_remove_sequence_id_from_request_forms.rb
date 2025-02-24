class RemoveSequenceIdFromRequestForms < ActiveRecord::Migration[7.2]
  def change
    remove_column :request_forms, :sequence_id, :integer
    drop_table :request_form_sequences
  end
end
