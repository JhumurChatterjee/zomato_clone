require 'date'
require 'time'
class Booking < ApplicationRecord
  belongs_to :restaurant
  belongs_to :user
  
  validate :check_last_date, on: [:create,:update]
  validates :name,:email,:phone,:requested_date,:requested_time,:no_of_guests, presence: true
  validates_length_of :phone, :minimum => 10, :maximum => 10

  def self.check_all_remained_seats
    @booking_deets=Array.new{Array.new}
    @status=Table.all
    @status.each do |st|
      @booking_deets=Booking.where("restaurant_id=?",st.restaurant_id).pluck(:id,:no_of_guests,:end_date,:end_time,:validity) 
      for i in 0..@booking_deets.size-1 do
        if @booking_deets[i][2] < Date.today && @booking_deets[i][4]==true
          
          Booking.where("id=?",@booking_deets[i][0]).update_all(validity: false)
        elsif @booking_deets[i][2].to_date == Date.today &&  Time.parse(@booking_deets[i][3].to_s(:time)) >= Time.parse((Time.now).to_s(:time))
          Booking.where("id=?",@booking_deets[i][0]).update_all(validity: true)
        elsif @booking_deets[i][2].to_date == Date.today &&  Time.parse(@booking_deets[i][3].to_s(:time)) <= Time.parse((Time.now).to_s(:time)) && @booking_deets[i][4]==true
          
          Booking.where("id=?",@booking_deets[i][0]).update_all(validity: false)
        elsif @booking_deets[i][2] > Date.today 
          Booking.where("id=?",@booking_deets[i][0]).update_all(validity: true)
        end
      end
    end
  end

  def self.check_seats(rest_id,date)
    @table=Table.find_by(restaurant_id: rest_id)
    @booking=Booking.where("requested_date = ? and restaurant_id=?", date, rest_id)
    t=@table.six_seater+@table.four_seater+@table.two_seater
      if @booking == []
        return true
      else
        @booking.each do |book|
          if book.validity==false
            t=t
          else
            t=t-book.no_of_guests.to_i
          end
        end
        return t
      end
  end

  def self.check_availability(guests,date,rest_id)
    @booking=Booking.where("requested_date = ? and restaurant_id=?",date,rest_id)
    @r=Table.find_by(restaurant_id: rest_id)
    t=@r.six_seater.to_i+@r.four_seater.to_i+@r.two_seater.to_i
    if @booking == []
      if guests.to_i<=t
        return true
      else
        return false
      end
    else
      @booking.each do |book|
        t=t-book.no_of_guests.to_i
      end
      if guests.to_i<=t
        return true
      else
        return false
      end
    end
  end

  def self.previous_booking(id)
    #idi=[]
    @booking = Booking.find(id)  
    if Date.today <= (@booking.end_date.to_date)-2.days && @booking.validity == true
      return true
    else
      return false
    end
  end   
  
  private
  def check_last_date
    
    if requested_date > Date.today+10.days
      errors.add(:requested_date, ": You can not place booking for after 10 days from now")
    elsif requested_date <= Date.today
      errors.add(:requested_date, ": You can not place booking for yesterday or before or today")
    end
  end
      
end

