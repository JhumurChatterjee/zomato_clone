require 'fileutils'
class Restaurant < ApplicationRecord
  has_one :table, :dependent => :destroy
  has_many :reviews, :dependent => :destroy
  has_many :posts, :dependent => :destroy
  has_many :orders, :dependent => :destroy
  has_many :bookings, :dependent => :destroy
  has_many_attached :restaurant_image
  belongs_to :location, optional: true

  serialize :food_menu, JSON
  serialize :food_item, Array
  
  validates :approved, acceptance: true

  $rest_id = Restaurant.count+1 
  
  def self.has_table(restaurant_id)
    Table.find_by(restaurant_id: restaurant_id)
  end

  def self.check_near(restaurant,city)
    @restaurant = Restaurant.find(restaurant.id)
    @c=[]      
    @c = Location.near(city,30)
    @c.each do |c|
      if c.full_address.downcase.gsub!(/\s+/, '') == restaurant.situated_at.downcase.gsub!(/\s+/, '')
        return true
      end
    end
    return false
  end
  
  
  
  
  
  
  def self.common_search(search)
    if search 
      where('name LIKE ?',"%#{search}%")
     else   
      all
    end

  end    
end
