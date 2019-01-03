class CreateBookings < ActiveRecord::Migration[5.2]
  def change
    create_table :bookings do |t|
      t.string :name
      t.string :email
      t.bigint :phone
      t.date :requested_date
      t.integer :no_of_guests
      t.time :requested_time

      t.timestamps
    end
  end
end
