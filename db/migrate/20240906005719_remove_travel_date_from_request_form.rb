class RemoveTravelDateFromRequestForm < ActiveRecord::Migration[7.2]
  def change
    remove_column :request_forms, :travel_date
  end
end
