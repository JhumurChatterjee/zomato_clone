class DropTableFoodMenus < ActiveRecord::Migration[5.2]
  def change
    drop_table :food_menus

  end
end
