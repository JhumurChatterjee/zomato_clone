class AddEncryptIdToBooking < ActiveRecord::Migration[5.2]
  def change
    add_column :bookings, :encrypt_id, :string
  end
end
