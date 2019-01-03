class Admin::BaseController < ApplicationController
  before_action :require_admin_login
  layout "admin"
  helper_method :admin?
  def require_admin_login
    unless current_user && current_user.admin == true
      flash[:error] = "You must be Admin to access this section"
      redirect_to root_url # halts request cycle
    end
  end
end
