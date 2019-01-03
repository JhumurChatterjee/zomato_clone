class AddHashToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :hash, :text
  end
end
