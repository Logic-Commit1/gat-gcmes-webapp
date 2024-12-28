class RemoveContactsFromClientsAndSuppliers < ActiveRecord::Migration[7.2]
  def change
    remove_column :clients, :contacts, :string
    remove_column :suppliers, :contacts, :string
  end
end
