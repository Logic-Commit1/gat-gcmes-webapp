class AddRejectionFieldsToTables < ActiveRecord::Migration[7.2]
  def change
    # Add columns to canvasses table
    add_column :canvasses, :rejector, :string
    add_column :canvasses, :rejected_at, :datetime

    # Add columns to quotations table
    add_column :quotations, :rejector, :string
    add_column :quotations, :rejected_at, :datetime

    # Add columns to request_forms table
    add_column :request_forms, :rejector, :string
    add_column :request_forms, :rejected_at, :datetime

    # Add columns to purchase_orders table
    add_column :purchase_orders, :rejector, :string
    add_column :purchase_orders, :rejected_at, :datetime
  end
end
