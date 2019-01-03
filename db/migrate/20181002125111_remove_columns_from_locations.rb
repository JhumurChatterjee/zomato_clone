class RemoveColumnsFromLocations < ActiveRecord::Migration[5.2]
  def change
   remove_column :locations,:street
   remove_column :locations,:state
   remove_column :locations,:country
   remove_column :locations,:location  
  end
end
