class AddTypeColumnToQuotations < ActiveRecord::Migration[7.2]
  def change
    add_column :quotations, :type, :integer
  end
end
