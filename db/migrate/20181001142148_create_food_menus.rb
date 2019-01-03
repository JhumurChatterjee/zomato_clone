class CreateFoodMenus < ActiveRecord::Migration[5.2]
  def change
    create_table :food_menus do |t|
      t.string :category
      t.string :image
      t.integer :restaurant_id

      t.timestamps
    end
  end
end
