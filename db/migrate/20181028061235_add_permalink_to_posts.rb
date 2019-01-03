class AddPermalinkToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :permalinks, :string
  end
end
