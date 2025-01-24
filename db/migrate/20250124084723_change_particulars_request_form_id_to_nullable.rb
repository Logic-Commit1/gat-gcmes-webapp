class ChangeParticularsRequestFormIdToNullable < ActiveRecord::Migration[7.2]
  def change
    change_column_null :particulars, :request_form_id, true
  end
end
