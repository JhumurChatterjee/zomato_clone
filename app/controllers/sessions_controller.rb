class SessionsController < ApplicationController
  include UserHelper
  
  def new
    current_user
    @user = User.new
    session[:route]=params[:from]
    session[:rest_id]=params[:restaurant_id]
  end

  def create
    if current_user
      login
    else
      @user = User.new(user_params)
      $Id=params[:id]

      if @user.save
        session[:user_id] = @user.id
        session[:email] = @user.email
        session[:username]=@user.username
        redirect_to root_url, notice: "Thank you for signing up! Please use same username or email and password to login"
      else
        flash.now[:error] = "Please Follow instruction below and try again...Good Luck!!"
        render 'index'
      end

    end
  end
  
  
  def auth_login
    auth=request.env['omniauth.auth']
    @authorization = Authorization.find_with_omniauth(auth)
    if @authorization.nil?
      @user=User.create_user_with_omniauth(auth)
      @authorization = Authorization.create_with_omniauth(auth,@user.id)
    end
    if signed_in?
      if @authorization.user==current_user
        redirect_to root_url, notice: "already linked that account"
      else
        @authorization.user = current_user
        @authorization.save
        redirect_to root_url, notice:"Successfully linked"
      end
    else
      if @authorization.user_id.present?
        self.current_user = User.find(@authorization.user_id)
        remember(current_user)
        session[:email]=current_user.email
        session[:username]=current_user.username
        redirect_to root_url, notice: "Signed in!"
      else
        redirect_to root_url, notice: "Please finish registering"
      end
    end
  end
  
  
  def login
    @user=User.new
    @authorized_user=User.find_by_username(params[:username_or_email])
    unless @authorized_user
      @authorized_user=User.find_by_email(params[:username_or_email])
    end

    if @authorized_user && @authorized_user.authenticate(params[:login_password])
      @authorized_user.password=params[:login_password]
      @authorized_user.password_confirmation=params[:login_password]

      if @authorized_user.admin==true
        session[:user_id] = @authorized_user.id
        cookies.permanent.signed[:email] = @authorized_user.email
        session[:email] = @authorized_user.email
        cookies.permanent.signed[:username] = @authorized_user.username
        session[:username]=@authorized_user.username
        
        params[:remember_me] == '1' ? remember(@authorized_user) : forget(@authorized_user)
        redirect_to admin_posts_path(@authorized_user.id)
      else  
        $Id=@authorized_user.id
        session[:user_id] = @authorized_user.id
        session[:email] = @authorized_user.email
        session[:username]=@authorized_user.username
        params[:remember_me] == '1' ? remember(@authorized_user) : forget(@authorized_user)
        flash[:success] = "Wow Welcome again, you logged in as #{@authorized_user.username}"

        if session[:route] == "restaurant"
          redirect_to show_restaurant_url(id: session[:rest_id])
        else
          render 'new'
        end

      end

    else
      flash[:notice]= "Invalid Username or Password"
      flash[:color]= "invalid"
      redirect_to profile_path	
    end
    @user=@authorized_user
  end


  def destroy
    log_out
    session[:user_id] = nil
    session[:email]=nil
    session[:username]=nil
    session[:restaurant_id]=nil
    redirect_to root_url, alert: "Logged out!"
  end


  def failure
    render :text => "Sorry, but you didn't allow to access to our app!"
  end

  private
  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

end
