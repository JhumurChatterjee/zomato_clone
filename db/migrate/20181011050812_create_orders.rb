class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.text :item
      t.integer :total
      t.string :full_address
      t.references :restaurant

      t.timestamps
    end
  end
end
