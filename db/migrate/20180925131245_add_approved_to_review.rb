class AddApprovedToReview < ActiveRecord::Migration[5.2]
  def change
    add_column :reviews, :approved, :boolean
  end
end
