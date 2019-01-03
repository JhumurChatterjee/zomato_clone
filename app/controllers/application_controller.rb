class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
 
  def check_id
    @o=[]
    $f=0
    @o=Order.where("user_id =? ",params[:user_id]).pluck(:id)

    for i in 0..@o.size-1 do
      if params[:id].to_i==@o[i]
        $f=1
      end
    end

    if  $f==0
      redirect_to show_restaurant_url(id: session[:restaurant_id]), notice: "Sorry!! You are not the desired user !!" 
    end
  end


  def set_value
    session[:user_id]=current_user.id
    session[:email]=current_user.email
    session[:username]=current_user.username
  end 


  def validate_url_hack
    unless params[:id].to_i == current_user.id
    # This line redirects the user to the previous action
      redirect_to root_url, notice: "You don't have access"
    end
  end


  def current_user
    if (session[:user_id])
      user_id = session[:user_id]
      @current_user ||= User.find_by(id: user_id) if session[:user_id]
    elsif (cookies.permanent.signed[:user_id])
      user_id = cookies.permanent.signed[:user_id]
      #raise       # The tests still pass, so this branch is currently untested.
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        
        @current_user = user
      end
    end
    @current_user
  end
  
  def require_login
    unless current_user
      flash[:error] = "You must be logged in to access this section"
      redirect_to root_url # halts request cycle
    end
  end
  def signed_in?
    !!current_user
  end
  
  
  def current_user=(user)
    session[:user_id] = user&.id
    @current_user = user
  end
  
  def check_email
    if params[:email] != nil
      if current_user && params[:email] != current_user.email
        redirect_to show_restaurant_url(id: session[:restaurant_id]), notice: "You don't have access to" 
      end
    end
  end


  def authorize
    if current_user.admin!=true
      posts = Post.where("user_id=?", current_user.id)
      if !posts.blank?
        posts.each do |post|
          if  post.user_id.to_i != current_user.id && current_user.admin != true
            redirect_to posts_url, alert: "Not authorized !!"
          end
 
        end
      else
        redirect_to root_url, notice: "No Posts!!"
      end
    end

  end      

  helper_method :current_user, :signed_in?,:require_login,:check_email,:authorize,:check_id
  def current_time
    @current_time = Time.now + 30.minutes
  end
  helper_method :current_time
  
end
