class AddRestaurantIdToBookings < ActiveRecord::Migration[5.2]
  def change
    add_reference :bookings,:restaurant,index: true,on_delete: :cascade
    add_reference :bookings,:table,on_delete: :cascade
  end
end
