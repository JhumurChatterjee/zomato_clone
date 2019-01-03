class AddEndTimeToBooking < ActiveRecord::Migration[5.2]
  def change
    add_column :bookings, :end_time, :time
  end
end
