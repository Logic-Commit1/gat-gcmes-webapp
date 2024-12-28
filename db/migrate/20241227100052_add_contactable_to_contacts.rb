class AddContactableToContacts < ActiveRecord::Migration[7.2]
  def change
    add_reference :contacts, :contactable, polymorphic: true, null: false
  end
end
