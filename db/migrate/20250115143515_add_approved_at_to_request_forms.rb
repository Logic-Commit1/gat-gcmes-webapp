class AddApprovedAtToRequestForms < ActiveRecord::Migration[7.2]
  def change
    add_column :request_forms, :approved_at, :datetime
  end
end

