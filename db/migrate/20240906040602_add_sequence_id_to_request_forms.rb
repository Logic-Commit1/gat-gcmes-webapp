class AddSequenceIdToRequestForms < ActiveRecord::Migration[7.2]
  def change
    add_column :request_forms, :sequence_id, :integer
  end
end
