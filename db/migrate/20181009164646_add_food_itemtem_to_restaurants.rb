class AddFoodItemtemToRestaurants < ActiveRecord::Migration[5.2]
  def change
    add_column :restaurants, :food_item, :string
  end
end
