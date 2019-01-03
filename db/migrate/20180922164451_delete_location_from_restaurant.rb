class DeleteLocationFromRestaurant < ActiveRecord::Migration[5.2]
  def change
    remove_column :restaurants, :location
  end
end
