class AddLocationToLocation < ActiveRecord::Migration[5.2]
  def change
    add_column :locations, :location, :string
    add_column :locations, :longitude, :decimal
    add_column :locations, :latitude, :decimal
    
  end
end
