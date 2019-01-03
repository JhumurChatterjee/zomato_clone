class AddSituatedAtToRestaurant < ActiveRecord::Migration[5.2]
  def change
    add_column :restaurants, :situated_at, :string
  end
end
