class AddReferenceToLocations < ActiveRecord::Migration[5.2]
  def change
    add_reference :locations, :user
  end
end
