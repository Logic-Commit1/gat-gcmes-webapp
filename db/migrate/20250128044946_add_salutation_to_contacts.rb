class AddSalutationToContacts < ActiveRecord::Migration[7.2]
  def change
    add_column :contacts, :salutation, :string
  end
end
