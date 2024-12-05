class AddContactNumbersAndEmailsToCompanies < ActiveRecord::Migration[7.2]
  def change
    add_column :companies, :contact_numbers, :jsonb, default: []
    add_column :companies, :emails, :jsonb, default: []
  end
end
