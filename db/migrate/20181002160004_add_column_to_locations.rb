class AddColumnToLocations < ActiveRecord::Migration[5.2]
  def change
    add_column :locations, :street, :string
    #add_column :locations, :city, :string
    add_column :locations, :country, :string
    add_column :locations, :state, :string
  end
end
