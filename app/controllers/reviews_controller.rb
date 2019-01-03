class ReviewsController < ApplicationController
  
  skip_before_action :verify_authenticity_token

  def index
   @review=Review.all 
  end

  def new
    @review = Review.new
  end
  
  def show
    @review = Review.find(params[:id])
    @restaurant = Restaurant.find(@review.restaurant_id)
  end

  def create
    @review = Review.new(review_param)
    if @review.save
      redirect_to controller: 'users', action: 'show_restaurant', id: @review.restaurant_id
    else
      render 'new'
    end
  end
  
  def edit
    @review = Review.find(params[:id])
  end
  
  def update
    @review = Review.find(params[:id])
    @post = Post.find_by_user_id(@review.user_id)
    if @review.update_attributes(review_param)
      if current_user.admin == false
        redirect_to review_url(id: @review.id), :notice  => "Successfully updated review."
      elsif current_user.admin == true
        redirect_to admin_restaurants_url, :notice  => "Successfully updated review."
      else
        render 'edit'
      end
    else
      render 'edit'
    end
  end
 
  def destroy
    Review.find(params[:id]).destroy
    redirect_to request.referer,:notice => "successfully deleted review"
  end

  private
  
  def review_param
    params.require(:review).permit(:rating,:comment,:user_id,:restaurant_id,:approved)
  end
 
end
