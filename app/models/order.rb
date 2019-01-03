class Order < ApplicationRecord
  belongs_to :user
  belongs_to :restaurant

  serialize :item, Array
  serialize :quantity, Array
  serialize :hashing, Hash

  validates :email,:phone,:item,:quantity,:full_address, presence: true
  validates_length_of :phone, :minimum => 10, :maximum => 10
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  

  def self.calculate_total(rest_id,menu)
    @total=0
    @restaurant=Restaurant.find(rest_id)
    for j in 0..menu.size-1 do
      for i in 0..@restaurant.food_menu.keys.size-1 do
        if menu[j].keys[0]==@restaurant.food_menu.keys[i]
          @total=@total+menu[j].values[0].to_i*@restaurant.food_menu.values[i].to_i
        end
      end
    end
    return @total
  end

  def self.check_validity(id)
    @order=Order.all
    @order.each do |order|
      if Time.parse((order.start_time+5.minutes).to_s(:time)) <= Time.parse((Time.now).to_s(:time)) && order.validity==true
        Order.find(order.id).update(validity: false)
      end
    end
  end
end
