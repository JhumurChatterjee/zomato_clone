class Admin::RestaurantsController < Admin::BaseController

  def index
    @restaurants=Restaurant.all
    
  end

  def new
    @restaurant = Restaurant.new
    session[:path]=""
  end

  def show
    @restaurant = Restaurant.find(params[:id])
    @location = Location.find_by_address(@restaurant.situated_at)
    
    @posts = Post.where(restaurant_id: params[:id])
    @posts.each do |post|
      @user=User.find(post.user_id)
    end
    @reviews = Review.search(params[:id])
  end

  def create
    @restaurant = Restaurant.new(restaurant_param)
    @restaurant.food_menu={}
    @restaurant.food_item=[]
    if @restaurant.save
      
      redirect_to admin_restaurants_url, :notice => "Successfully created restaurant."
    else
      render :action => 'new'
    end
  end

  def edit
    @restaurant = Restaurant.find(params[:id])
  end

  def update
    i=1;j=2
    @restaurant = Restaurant.find(params[:id])
    if params[:restaurant][:food_item] != nil
      params[:restaurant][:food_item].each { |item| item.downcase! }
      @restaurant.food_menu = params[:restaurant][:food_item].each_slice(2).map { |value| Hash[value[0],value[1]] }

      i=0
      j=@restaurant.food_menu.size-1
      @restaurant.food_menu = Hash[
      @restaurant.food_menu.each.map do |key|
        [ key.keys[0].gsub(/\s/,'_'), key.values[0] ]
      end
    ]
    end
    if @restaurant.update_attributes(restaurant_param)
      redirect_to admin_restaurants_url, :notice  => "Successfully updated restaurant."
    else
      render :action => 'edit'
    end
  end


  def destroy
    @restaurant = Restaurant.find(params[:id])
    
    @restaurant.destroy
    redirect_to admin_restaurants_url, :notice => "Successfully destroyed Restaurant."
  end


  def new_food
    @restaurant = Restaurant.find(params[:id])
     
  end
 

  def new_food_create
    @restaurant = Restaurant.find(params[:id])
    params[:restaurant][:food_item].each_slice(2) { |item| item[0].downcase! }
   
    params[:restaurant][:food_item].each_slice(2).map { |value|
    @restaurant.food_menu.merge!(Hash[value[0],value[1]]) }
    params[:restaurant][:food_item].each do |item|
      @restaurant.food_item << item
    end
    i=0
    j=@restaurant.food_menu.size-1
    @restaurant.food_menu = Hash[
      @restaurant.food_menu.each.map do |key,value|
        [ key.gsub(/\s/,'_'), value ]
      end
    ]
    if @restaurant.update!(food_menu: @restaurant.food_menu)
      
      redirect_to admin_food_show_url(id: @restaurant.id)
    else
      render 'new_food'
    end
  end


  def food_show
    @restaurant = Restaurant.find(params[:id])  
  end


  def edit_food
    @restaurant = Restaurant.find(params[:id])
  end
  

  def edit_food_update
    @restaurant=Restaurant.find(params[:id])
    @restaurant.food_item=[]
    @restaurant.food_menu ={}
    params[:restaurant][:food_item].each_slice(2) { |item| item[0].downcase! }
    params[:restaurant][:food_item].each_slice(2).map { |value|
    @restaurant.food_menu.merge!(Hash[value[0],value[1]]) }
    params[:restaurant][:food_item].each do |item|
      @restaurant.food_item << item
    end
    i=0
    j=@restaurant.food_menu.size-1
    @restaurant.food_menu = Hash[
      @restaurant.food_menu.each.map do |key,value|
        [ key.gsub(/\s/,'_'), value ]
      end
    ]
    if @restaurant.update!(food_menu: @restaurant.food_menu)
      
      redirect_to admin_food_show_url(id: @restaurant.id)
    else
      render 'edit_food'
    end
  end


  def delete_food
    @restaurant = Restaurant.find(params[:id])
    @restaurant.food_menu.each do |k,v|
      if params[:item].gsub(/\s/,'_') == k
        @restaurant.food_menu.delete(k)
      end
    end
    @restaurant.food_item.each_slice(2) do |item|
      if params[:item]==item[0]
        @restaurant.food_item.delete(item[0])
        @restaurant.food_item.delete(item[1])
      end
    end
    if @restaurant.update!(food_menu: @restaurant.food_menu, food_item: @restaurant.food_item)
      
      redirect_to admin_food_show_url(id: @restaurant.id)
    else
      render 'food_show'
    end
  end  


  def delete_image_attachment
    @restaurant_image = ActiveStorage::Attachment.find(params[:id])
    @restaurant_image.purge
    redirect_back fallback_location: request.referer
  end

  private

  def restaurant_param
    params.require(:restaurant).permit(:name,:category,:situated_at,:location_id,:restaurant_image => [])
    
  end
 
end
