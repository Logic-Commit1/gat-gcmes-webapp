class AddCompanyColumnToQuotations < ActiveRecord::Migration[7.2]
  def change
    add_column :quotations, :company, :integer
  end
end
