class DeleteHashingToOrders < ActiveRecord::Migration[5.2]
  def change
    remove_column :orders, :hash
  end
end
