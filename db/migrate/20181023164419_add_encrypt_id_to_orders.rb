class AddEncryptIdToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :encrypt_id, :string
  end
end
