class AddColumnsToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :start_time, :time
    add_column :orders, :end_time, :time
    add_reference :orders, :user, index:true
  end
end
