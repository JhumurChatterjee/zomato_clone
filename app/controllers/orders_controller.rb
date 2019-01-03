class OrdersController < ApplicationController
  before_action :check_id, :only => [:show]

  def index 
    if current_user.id == params[:user_id].to_i
      @order=Order.where("user_id = ? and restaurant_id = ?",current_user.id,session[:restaurant_id])
    else
      redirect_to show_restaurant_url(id: session[:restaurant_id]), notice: "You don't have access"
    end
  end
  
  def show
    @order = Order.find(params[:id])
    @restaurant = Restaurant.find(params[:restaurant_id])
    Order.check_validity(@order.id)
    from=@restaurant.situated_at.downcase.gsub!(/\s+/, '')
    to=@order.full_address.downcase.gsub!(/\s+/, '')
    @locations=Location.all

    @locations.each do |loc|
      if loc.full_address.downcase.gsub!(/\s+/, '') == from
        if from==to
          @location_from=loc
          @location_to=loc
        else
          @location_to=loc
        end
      elsif loc.full_address.downcase.gsub!(/\s+/, '') == to
        if from==to
          @location_from=loc
          @location_to=loc
        else
          @location_from=loc
        end
      end

    end

    @distance=Geocoder::Calculations.distance_between([@location_to.latitude,@location_to.longitude],[@location_from.latitude,@location_from.longitude])
    if @distance < 10
      @delivery=40
    else
      @delivery=100
    end
  end

  def new
    $address=params[:address]
    
    @order=Order.new
    @addressess = current_user.locations 
    @restaurant=Restaurant.find(session[:restaurant_id])
  end

  def create
    @order=Order.new(order_param)
    @restaurant=Restaurant.find(session[:restaurant_id])
    i=0
    
    if params[:order][:full_address] == nil
      flash.now[:notice]=  "Please Provide address"
      render 'new'
    else

      if params[:order][:item] != nil
        for i in 0..@restaurant.food_menu.keys.size-1 do 
          for j in 0..params[:order][:item].size-1 do
            if params[:order][:item][j]!=@restaurant.food_menu.keys[i] && j==i
              params[:order][:quantity][i]=0
            else
              break     
            end
          end
        end
      
        for i in 0..params[:order][:quantity].size-1 do 
          if params[:order][:quantity][i]==0 && params[:order][:quantity][i+1]!=nil
            params[:order][:quantity][i]=params[:order][:quantity][i+1]
            params[:order][:quantity].pop
          end
        end
    
        for i in 0..params[:order][:item].size-1 do
          @order.hashing[i]=Hash[params[:order][:item][i],params[:order][:quantity][i]]
        end
      end

      @order.total=Order.calculate_total(@order.restaurant_id,@order.hashing)
      @order.start_time =  Time.now+5.hours+30.minutes
      @order.end_time = @order.start_time+45.minutes
      from=@restaurant.situated_at.downcase.gsub!(/\s+/, '')
      to=@order.full_address.downcase.gsub!(/\s+/, '')
      @locations=Location.all

      @locations.each do |loc|
        if loc.full_address.downcase.gsub!(/\s+/, '') == from
          if from==to
            @location_from=loc
            @location_to=loc
          else
            @location_to=loc
          end
        elsif loc.full_address.downcase.gsub!(/\s+/, '') == to
          if from==to
            @location_from=loc
            @location_to=loc
          else
            @location_from=loc
          end
        end
      end

      @distance=Geocoder::Calculations.distance_between([@location_to.latitude,@location_to.longitude],[@location_from.latitude,@location_from.longitude])
      
      
    
      if @distance > 40
        redirect_to show_restaurant_url(id: @restaurant.id), notice: "We do not deliver near your locality" and return
      end
   
      @order.encrypt_id = SecureRandom.urlsafe_base64
      if @order.save
        redirect_to order_url(restaurant_id: @order.restaurant_id,user_id: session[:user_id],id: @order.id,email: session[:email]), notice: "Successfully Order placed"
      else
        @addressess = current_user.locations 
        params[:address]=$address
        
        render 'new', :locals => {:address => params[:address]}, collection: @addressess
      end
    end
  end

  def destroy
    @order=Order.find(params[:id]).destroy
    redirect_to show_restaurant_url(id: session[:restaurant_id]),notice: "Order Deleted"
  end
  
  private
  
  def order_param
    params.require(:order).permit(:total,:full_address,:restaurant_id,:user_id,:phone,:email,:item => [],quantity: [])
  end

end
