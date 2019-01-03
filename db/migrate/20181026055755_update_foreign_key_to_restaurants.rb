class UpdateForeignKeyToRestaurants < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :restaurants, :locations
    add_foreign_key :restaurants, :locations, on_delete: :cascade
  end
end
