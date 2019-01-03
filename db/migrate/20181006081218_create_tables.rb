class CreateTables < ActiveRecord::Migration[5.2]
  def change
    create_table :tables do |t|
      t.integer :four_seater
      t.integer :six_seater
      t.integer :two_seater
      t.references :restaurant, foreign_key: true

      t.timestamps
    end
  end
end
