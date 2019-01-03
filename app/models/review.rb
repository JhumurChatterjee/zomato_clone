class Review < ApplicationRecord
  belongs_to :user
  belongs_to :restaurant

  def self.search(restaurant_id)
    where("restaurant_id=?",restaurant_id)
  end
end
