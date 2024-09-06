class AddStartAndEndDateToRequestForm < ActiveRecord::Migration[7.2]
  def change
    add_column :request_forms, :start_travel_date, :datetime
    add_column :request_forms, :end_travel_date, :datetime
  end
end
