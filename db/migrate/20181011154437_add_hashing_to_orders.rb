class AddHashingToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :hashing, :text
  end
end
