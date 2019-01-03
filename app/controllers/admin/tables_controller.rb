class Admin::TablesController < Admin::BaseController
  before_action :limit_table, only: [:new,:create]

  def index
    @restaurant=[]
    i=0
    @tables=Table.all
    @tables.each do |table|
      @restaurant[i]=Restaurant.find(table.restaurant_id)
      i+=1
    end
  end

  def new
    @table=Table.new
  end

  def show
    @table=Table.find(params[:id])
    @restaurant=Restaurant.find(@table.restaurant_id)
  end

  def create
    @table=Table.new(table_param)
    
      if @table.save
        redirect_to admin_tables_url
      else
        render :new
      end
  end
  
  def edit
    @table = Table.find(params[:id])
  end

  def update
    @table=Table.find(params[:id])
    #@table.remaining = params[:table][:six_seater].to_i + params[:table][:four_seater].to_i + params[:table][:two_seater].to_i
    if @table.update_attributes(table_param)
      redirect_to admin_tables_url, :notice  => "Successfully updated table."
    else
      render :action => 'edit'
    end
  end


  private

  def limit_table
    restaurant_table=Restaurant.has_table(params[:id])
    if restaurant_table.present?
      redirect_to admin_restaurants_path(id: session[:restaurant_id]),notice:"You have already added table"
    end
  end

  def table_param
    params.require(:table).permit(:six_seater,:four_seater,:two_seater,:restaurant_id)
  end
end
