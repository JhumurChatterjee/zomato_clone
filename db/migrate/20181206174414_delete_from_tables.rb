class DeleteFromTables < ActiveRecord::Migration[5.2]
  def change
    remove_column :tables, :remaining
  end
end
