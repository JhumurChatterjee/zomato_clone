class AddRemainingToTables < ActiveRecord::Migration[5.2]
  def change
    add_column :tables, :remaining, :integer
  end
end
