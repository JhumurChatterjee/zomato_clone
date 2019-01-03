require 'pp'
class Location < ApplicationRecord
  has_many :restaurants, dependent: :destroy
  belongs_to :user
  geocoded_by :full_address  
  
  after_validation :geocode
  
  after_validation :geocode, if: ->(obj){ obj.address.present? and obj.address_changed? }
  
  after_validation :reverse_geocode
  
  def full_address
    [street,city,state,country].compact.join(', ')
  end

  def self.check_or_create_address(address)
    @locs = Location.all
    if @locs.blank?
      return false
    else
      @locs.each do |l|
        @loc_id = Location.where("lower(full_address) like ?","%#{address}%").first
        if @loc_id
          return @loc_id.id
        else
          @loc_id=false
        end
      end
    end
    return @loc_id
  end

  def self.check(search)
    @full=Array.new{Array.new}
    @restaurant=[]
    @r=[]
    i=0
    @locations=Location.where("lower(city) like ?","%#{search}%")
    if @locations == []
      return []
    end
    @locations.each do |loc|
      @near_locations=Location.near(loc.full_address,30)
    end
    @near_locations.each do |near|
      near.city.downcase!
      @full[i]=Location.where("lower(city) like ?","%#{near.city}%").pluck(:full_address)
      i+=1
    end
    i=0
    j=0
    k=0
    @full.uniq!
    for i in 0..@full.size-1 do
      @full[i].each do |f|
        if f
          @restaurant[k] = f.downcase.gsub!(/\s+/, '')
          k+=1
        end
      end
    end
    k=0
    for i in 0..@restaurant.size-1 do
      @restaurants=Restaurant.all
      @restaurants.each do |restaurant|
        if restaurant.situated_at.downcase.gsub!(/\s+/, '') == @restaurant[i]
          @r[k]=restaurant.id
          k+=1
        end
      end      
    end
    @r.uniq!
    return @r
  end
  
end
