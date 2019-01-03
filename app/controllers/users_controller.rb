class UsersController < ApplicationController
  before_action :require_login, :only => [:edit,:update]
  before_action :validate_url_hack, :only=>[:edit,:update]
  before_action :set_value, :except=> [:common_search,:search,:show_all_restaurant,:show_restaurant]
  include UserHelper
 
  def index
    @user=params[:user]
  end

  def new
    current_user
    @user=User.new
    session[:route]=params[:from]
    session[:rest_id]=params[:restaurant_id]
  end

  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user=User.find(params[:id])
    @user.skip_password_validation = true
    @user.attributes = user_params
    if @user.save
      redirect_to posts_url(id: current_user.id), :notice  => "Successfully updated your details."
    else
      flash.now[:notice]="Enter Password and Password confirmation both to change it"
      render :action => 'edit'
    end
  end

  def contact
  end


  def common_search
    @result = []
    @nearby=[]
    @restaurants_from_loc=[]
    @reviews=[]
    k=0
    if params[:search].blank?  
      redirect_to(request.referer, alert: "Empty field!") and return  
    else  
      @parameter = params[:search].downcase  
      @restaurants = Restaurant.where("lower(name) LIKE ?","%#{@parameter}%") 
      for i in 0..@restaurants.size-1 do
        @reviews[i] = Review.where("restaurant_id=? and approved = ?",@restaurants[i].id,true).pluck(:rating)
      end
      if @restaurants==[]
        @nearby=Location.check(@parameter)
      end  
      if @nearby != [] || @nearby != nil
        @nearby.each do|n|
          if n!=nil
            @restaurants_from_loc[k]=Restaurant.find(n)
            @reviews[k] = Review.where("restaurant_id=? and approved = ?",@restaurants_from_loc[k].id,true).pluck(:rating)        
            k+=1
          end
        end
      else
        @nearby = []
      end
      
      i=0
      if (@nearby == [] || @nearby == nil )&& @restaurants == []
        @food = @parameter.gsub(/\s/,'_')
        @result_city=Geocoder.search(request.location)
        @city=@result_city.first.city 
        @restaurant = Restaurant.all
        @restaurant.each do |restaurant|
          @reviews[i] = Review.where("restaurant_id=? and approved = ?",restaurant.id,true).pluck(:rating)
          restaurant.food_menu.each do |key,value|
            if @food == key.downcase
              if Restaurant.check_near(restaurant,@city)
                @result[i] = restaurant
                i+=1
              end
            end
          end
        end
      end
    end
  end

  def search
    @reviews=[]
    @restaurants=Array.new{Array.new}
    i=0
    if params[:category] != nil
      if params[:category].downcase == "cafe"
        @restaurants[i] = Restaurant.where("lower(category) = ?",params[:category].downcase)
      
      elsif params[:category].downcase == "multi-cuisine"
        @restaurants[i] = Restaurant.where("lower(category) = ?",params[:category].downcase)
      
      else
        @restaurants[i] = Restaurant.where("lower(category) = ?",params[:category].downcase)
      
      end
      i+=1
      for i in 0..@restaurants.size-1 do
        for j in 0..@restaurants[i].size-1 do 
          @reviews[j] = Review.where("restaurant_id=? and approved = ?",@restaurants[i][j].id,true).pluck(:rating)
        
        end 
      end
    end
  end  

  def show_restaurant
    session[:restaurant_id]=params[:id]
    i=0
    j=0
    @booking=[]
    @user=[]
    @users=[]
    @posts=[]
    @reviews=[]
    @restaurant = Restaurant.find(params[:id])
    @reviews = Review.where("restaurant_id=? and approved=?", params[:id],true)
    @reviews.each do |r|
      @users[j]=User.find(r.user_id)
      j+=1
    end
    @posts=Post.where("restaurant_id=? and approved=?", params[:id],true)
    @posts.each do |p|
      @user[i]=User.find(p.user_id)
      i+=1
    end
    @location=Location.find(@restaurant.location_id) if @restaurant.location_id!=nil
    if current_user!=nil
      @order=Order.where("user_id = ? and restaurant_id = ?",current_user.id, @restaurant.id)
      @booking = Booking.where("user_id = ? and restaurant_id =?", current_user.id, @restaurant.id) 
    end
  end
  
  def show_booking 
    
  end

  def show_all_restaurant
    @reviews=[]
    @near_restaurants=Array.new{Array.new}
    @restaurant=[]
    @nearby_city=[]
    @result=Geocoder.search(request.location)
    @city=@result.first.city
    @nearby_city = Location.near(@city, 30)
    @loc=Array.new{Array.new}
    i=0
    @cities=[]
    for j in 0..@nearby_city.size-1 do
      @cities[j]=@nearby_city[j].city
    end
    @cities.uniq!
    k=0
    for i in 0..@cities.size-1 do
      @cities[i].downcase!
      @loc=Location.where("lower(city) like ?","%#{@cities[i]}%").pluck(:full_address)
      @loc.uniq!
      @loc.each do |l|
        
        @restaurants=Restaurant.all
        @restaurants.each do |restaurant|
          if restaurant.situated_at.downcase.gsub!(/\s+/, '') == l.downcase.gsub!(/\s+/, '')
            @restaurant[k]=restaurant
            k+=1
          end
        end
        
      end
    end
    if !@restaurant.blank?
      for j in 0..@restaurant.size-1 do 
        @reviews[j] = Review.where("restaurant_id = ? and approved = ?", @restaurant[j], true).pluck(:rating)
      end 
    end  
    @restaurant.uniq!
  end  
      
     
  private
  
  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
  
end
