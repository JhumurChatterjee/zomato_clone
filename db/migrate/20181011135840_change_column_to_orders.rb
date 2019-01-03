class ChangeColumnToOrders < ActiveRecord::Migration[5.2]
  def change
    change_column :orders, :quantity,:text
  end
end
