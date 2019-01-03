class PostsController < ApplicationController
  before_action :authorize, only: [:show,:edit,:update,:delete]
  skip_before_action :verify_authenticity_token

  def index
    i=0
    j=0
    @restaurant=[]
    @posts=[]
    @reviews=[]
    @restaurants=[]
    if current_user.id == nil
      @posts = nil
    else
      @user=User.find(current_user.id)
      @posts=Post.where("user_id =?", @user.id)
      @posts.each do |p|
        if p.user_id==current_user.id
          @restaurant[i] = Restaurant.find(p.restaurant_id)
          i+=1
        else
          redirect_to posts_url, notice: "Don't peep into othrs' account !!!"
        end
      end
      @reviews = Review.where("user_id=?",current_user.id)
      @reviews.each do |review|
        @restaurants[j]=Restaurant.find(review.restaurant_id)
        j+=1
      end
    end
  end

  def new
    @post = Post.new
  end
 
  def show
    i=0
    @review=[]
    @post=Post.find(params[:id])
    @restaurant = Restaurant.find(@post.restaurant_id)
    $post_id=@post.id
    @review = Review.where("user_id = ? and restaurant_id = ?",@current_user.id,@restaurant.id).to_a
  end
  
  def post_params
   params.require(:post).permit(:body,:user_id,:restaurant_id,:approved,:image => [])
  end

  def create
    @post = Post.new(post_params)
    $user_id = @post.user_id	
    if @post.save
      redirect_to show_restaurant_url(id: session[:restaurant_id])
    else
      render :action => 'new'
    end
  end

  def edit
    @post=Post.find(params[:id])
  end

  def post_param
   params.require(:post).permit(:body,:user_id,:approved,:image => [])
  end

  def update
    @post=Post.find(params[:id])
    if @post.update_attributes(post_param)
      if current_user.admin == true
        redirect_to admin_restaurants_url, :notice  => "Successfully updated post."
      else
        redirect_to post_url(id: @post.id), :notice => "Successfully updated your post"
      end
    else
      render :action => 'edit'
    end
  end

  def delete
    @post=Post.find(params[:id])
    @post.destroy
    redirect_to :action => 'index'
  end

  def delete_image_attachment
    @image = ActiveStorage::Attachment.find(params[:id])
    @image.purge
    redirect_back fallback_location: request.referer
  end

  
end
