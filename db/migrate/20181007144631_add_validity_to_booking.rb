class AddValidityToBooking < ActiveRecord::Migration[5.2]
  def change
    add_column :bookings, :validity, :boolean, default: true
  end
end
