require 'resolv-replace'
class Admin::LocationsController < Admin::BaseController 
  @path=""
  @restaurant_id=0

  def index
    @locations = Location.all
    @location= request.ip
  end


  def show
    @location = Location.find(params[:id])

  end


  def new
    @location = Location.new
     if params[:from] == "restaurant" 
       session[:path]="restaurant"
     elsif params[:from]=="order"
       session[:path]="order"  
     end
     session[:restaurant_id]=params[:restaurant_id]
     session[:my_previous_url] = URI(request.referer || '').path
  end


  def create
    @location = Location.new(location_param)
    @results=Geocoder.search(@location.full_address)
    @location.latitude,@location.longitude=@results.first.coordinates
    @location.full_address=@location.full_address

    if session[:path] == "restaurant" 
      @loc_id=Location.check_or_create_address(@location.full_address.downcase)
      if @loc_id
        redirect_to new_admin_restaurant_url(address: @location.full_address,id: @loc_id)
      else
        @location.save
        redirect_to new_admin_restaurant_url(address: @location.full_address,id: @location.id)
      end

    elsif session[:path]=="order"
      @loc_id=Location.check_or_create_address(@location.full_address.downcase)
      if @loc_id
        redirect_to new_order_url(address: @location.full_address,id: @loc_id,restaurant_id: session[:restaurant_id])
      else
        @location.save
        redirect_to new_order_order_url(address: @location.full_address,id: @loc_id,restaurant_id: session[:restaurant_id])
      end

    else
      if @location.save
        redirect_to admin_locations_url, :notice => "Successfully created location."
      else
        render :action => 'new'
      end

    end
  end


  def edit
    @location = Location.find(params[:id])
  end


  def update
    @location = Location.find(params[:id])
    if @location.update_attributes(location_param)
      redirect_to admin_locations_url, :notice  => "Successfully updated location."
    else
      render :action => 'edit'
    end
  end


  def destroy
    @location = Location.find(params[:id])
    @location.destroy
    redirect_to admin_locations_url, :notice => "Successfully destroyed location."
  end


  private
  
  def location_param
    params.require(:location).permit(:country,:state,:street,:city,:longitude,:latitude)
  end

end
