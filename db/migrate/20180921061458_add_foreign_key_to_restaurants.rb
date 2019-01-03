class AddForeignKeyToRestaurants < ActiveRecord::Migration[5.2]
  def change
    add_reference :restaurants, :location, index: true, on_delete: :cascade
  end
end
