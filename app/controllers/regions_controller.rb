class RegionsController < ApplicationController
  def index
    @regions = Region.all
    @meters = Meter.all
  end

  def show
    @region = Region.find(params[:id])
    @meters = Meter.where(region_id: @region.id).order(params[:sort])


  end

  def new
    @page_title = 'Добавить новый регион'
    @region = Region.new
  end

  def create
    @region = Region.new(region_params)
    if @region.save
      flash[:notice] = 'Регион добавлен'
      redirect_to regions_path
    else
      render 'new'
    end
  end

  def edit
    @region = Region.find(params[:id])
  end

  def update
    @region = Region.find(params[:id])
    if @region.update(region_params)
      flash[:notice] = 'Регион обновлен'
      redirect_to regions_path
    else
      render 'new'
    end
  end

  def destroy
    @region = Region.find(params[:id])
    @region.destroy
    flash[:alert] = 'Регион удалён'
    redirect_to regions_path
  end

  private def region_params
    params.require(:region).permit(:name)
  end
end
