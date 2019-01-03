class AddRestaurantIdToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :restaurant_id, :integer
  end
end
