class CreateRestaurants < ActiveRecord::Migration[5.2]
  def change
    create_table :restaurants do |t|
      t.string :name
      t.string :type
      t.string :location
      t.text :food_menu
 
      t.timestamps
    end
  end
end
