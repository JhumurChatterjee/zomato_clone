class AddValidityToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :validity, :boolean, default: true
  end
end
