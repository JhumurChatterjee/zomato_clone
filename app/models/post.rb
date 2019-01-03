class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :restaurant
 
  has_many_attached :image
  
  
 
end
