class CreateRequestForms < ActiveRecord::Migration[7.2]
  def change
    create_table :request_forms do |t|
      t.string :uid
      t.string :type
      t.string :vehicle
      t.date :travel_date
      t.string :destination
      t.decimal :total
      t.text :remarks
      t.string :fuel_gauge
      t.decimal :easy_trip_balance
      t.decimal :sweep_balance
      t.string :requester
      t.string :checker
      t.string :procurer
      t.string :pre_approver
      t.string :approver
      t.references :canvass, null: false, foreign_key: true
      t.references :quotation, null: false, foreign_key: true
      t.references :company, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
