class CreateContacts < ActiveRecord::Migration[7.2]
  def change
    create_table :contacts do |t|
      t.string :name
      t.jsonb :emails, default: []
      t.jsonb :contact_numbers, default: []

      t.timestamps
    end
  end
end
