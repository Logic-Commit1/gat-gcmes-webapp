class AddApprovedAtToQuotations < ActiveRecord::Migration[7.2]
  def change
    add_column :quotations, :approved_at, :datetime
  end
end
