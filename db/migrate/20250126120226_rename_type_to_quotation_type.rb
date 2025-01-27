class RenameTypeToQuotationType < ActiveRecord::Migration[7.2]
  def change
    rename_column :quotations, :type, :quotation_type
  end
end
