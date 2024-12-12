class AddStatusToQuotations < ActiveRecord::Migration[7.2]
  def change
    add_column :quotations, :status, :integer, default: 0
  end
end
