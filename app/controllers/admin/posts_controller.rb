class Admin::PostsController < Admin::BaseController
  before_action :require_admin_login

  def index
    @users=User.all 
  end  

  def show_user_details
    @user=User.find(params[:id])
  end

  def show_posts
    @post=Post.find(params[:id])
  end

  def edit_post
    @post=Post.find(params[:id])
  end

  def all_bookings
    Booking.check_all_remained_seats
    @booking=Booking.all
  end

  def update
    @post=Post.find(params[:id])
    if @post.update_attributes(post_param)
      redirect_to :action => 'show_posts',:id => @post.id 
    else
      render :action => 'edit_post'
    end
  end

  def orders
    @restaurants=[] 
    i=0
    @orders = Order.includes(:restaurant).all
    @orders.each do |order|
      Order.check_validity(order.id)
      @restaurants[i]=order.restaurant.name
      i+=1
    end
  end
 
end
