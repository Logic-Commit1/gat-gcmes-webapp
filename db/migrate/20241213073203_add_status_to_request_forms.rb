class AddStatusToRequestForms < ActiveRecord::Migration[7.2]
  def change
    add_column :request_forms, :status, :integer, default: 0
  end
end
