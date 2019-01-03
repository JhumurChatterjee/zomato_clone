class BookingsController < ApplicationController
  before_action :check_email, :only => [:show,:edit,:update]

  def index
    Booking.check_all_remained_seats

    if current_user.email==params[:email] || params[:email]==""
      @bookings=Booking.where("user_id = ? and restaurant_id =?", current_user.id, params[:restaurant_id])
    else
      redirect_to show_restaurant_url(id: session[:restaurant_id]), notice: "You don't have access"
    end

    @table=Table.find_by(restaurant_id: session[:restaurant_id])
    @seats=[]

    for i in 0..10 do
      @booking=Booking.where("requested_date = ? and restaurant_id= ?", Date.today+i.days, session[:restaurant_id])
      t=@table.six_seater+@table.four_seater+@table.two_seater

      if @booking == [] && Booking.check_seats(session[:restaurant_id],Date.today+i.days) == true
        @seats[i] = t
      elsif @booking != [] && Booking.check_seats(session[:restaurant_id],Date.today+i.days) != true
        
        @seats[i] = Booking.check_seats(session[:restaurant_id],Date.today+i.days)
      end

    end
  end

  def new
    @booking=Booking.new
    Booking.check_all_remained_seats
    @table=Table.find_by(restaurant_id: session[:restaurant_id])
  end

  def show
    @check=0
    i=0
    Booking.check_all_remained_seats 
    @booking=Booking.find(params[:id])
    if params[:email] != @booking.email
      redirect_to bookings_url(email: session[:email],restaurant_id: session[:restaurant_id]), notice: "You are caught while peeping !!!!"
    end
    
    if Booking.previous_booking(@booking.id)
      @check=1
    else
      @check=0
    end

  end

  def create
    @booking=Booking.new(booking_param)
    @booking.encrypt_id = SecureRandom.urlsafe_base64
    Booking.check_all_remained_seats

    if Booking.check_availability(@booking.no_of_guests,@booking.requested_date,session[:restaurant_id])
      
      @booking.requested_time=@booking.requested_time
      @booking.end_time=@booking.requested_time+60.minutes
      @booking.end_date=@booking.requested_date

      if @booking.save
        flash[:success] ="Successfully booked"
        redirect_to booking_url(email: @booking.email,id: @booking.id)
      else
        render 'new', :locals => {:restaurant_id => session[:restaurant_id]}
      end

    else 
      redirect_to request.referer, :notice => "Booking not Possible.. No seat available.."
      
    end

  end


  def edit
    Booking.check_all_remained_seats
    @table=Table.find_by(restaurant_id: session[:restaurant_id])
    @booking=Booking.find(params[:id]) 
    params[:restaurant_id]=@booking.restaurant_id
    if @booking==""
      request_to request.referer, notice: "no records"
    end
  end

 
  def update
    @booking=Booking.find(params[:id])
    if Booking.check_availability(params[:booking][:no_of_guests],params[:booking][:requested_date],session[:restaurant_id])
      if @booking.update_attributes(booking_param)
        redirect_to bookings_url(restaurant_id: @booking.restaurant_id,email: @booking.email), :notice  => "Successfully updated booking."
      else
        render :action => 'edit'
      end
    else
      redirect_to request.referer, :notice => "Booking not Possible.. No seat available"
    end
  end


  def destroy
    @booking=Booking.find(params[:id])
    #Booking.update_table_edit(params[:id],@booking.no_of_guests)
    @booking.destroy
    redirect_to bookings_url(restaurant_id: session[:restaurant_id],email: session[:email]),:notice=>"Successfully deleted booking"
  end

  private
  def booking_param
    params.require(:booking).permit(:name,:requested_date,:requested_time,:email,:phone,:no_of_guests,:restaurant_id,:user_id)
  end
end
