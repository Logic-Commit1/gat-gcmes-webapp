class AddSalesInvoiceToProjects < ActiveRecord::Migration[7.2]
  def change
    add_column :projects, :sales_invoice, :string
  end
end
