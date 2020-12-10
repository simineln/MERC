class MetersController < ApplicationController

  def index
    @meters = Meter.order(params[:sort])
  end

  def new
    @page_title = 'Добавить новый счётчик'
    @meter = Meter.new
  end

  def create
    @meter = Meter.new(meter_params)
    if @meter.save
      flash[:notice] = 'Счётчик добавлен'
      redirect_to meters_path
    else
      render 'new'
    end
  end

  def edit
    @meter = Meter.find(params[:id])
  end

  def update
    @meter = Meter.find(params[:id])
    if @meter.update(meter_params)
      flash[:notice] = 'Счётчик изменён/заменён'
      redirect_to meters_path
    else
      render 'new'
    end
  end

  def destroy
    @meter = Meter.find(params[:id])
    @meter.destroy
    flash[:alert] = 'Счётчик удалён'
    redirect_to meters_path
  end

  def hour
    @meter = Meter.find(params[:id])

    if params[:datepicker]
      daterange = params[:daterange].split("to")
      @readings = Reading.where(meter_id: @meter.id).where(date: daterange[0].to_date..daterange[-1].to_date + 1)
    else
      @readings = Reading.where(meter_id: @meter.id)
    end

    @aec_sum = [@readings.sum(:aec_p), @readings.sum(:aec_m)]
    @rec_sum = [@readings.sum(:rec_p), @readings.sum(:rec_m)]
    @ad_sum = [@readings.sum(:ad_p), @readings.sum(:ad_m)]
  end

  def day
    @meter = Meter.find(params[:id])

    if params[:datepicker]
      daterange = params[:daterange].split("to")
      @readings = Reading.where(meter_id: @meter.id).where(date: daterange[0].to_date..daterange[-1].to_date + 1)
    else
      @readings = Reading.where(meter_id: @meter.id)
    end
    
    @readingsDay = @readings.group_by_day(:date)

    @aec_sum = [@readings.sum(:aec_p), @readings.sum(:aec_m)]
    @rec_sum = [@readings.sum(:rec_p), @readings.sum(:rec_m)]
    @ad_sum = [@readings.sum(:ad_p), @readings.sum(:ad_m)]

    # Generating hashes for sum values
    @aec = [@readingsDay.sum(:aec_p), @readingsDay.sum(:aec_m)]
    @rec = [@readingsDay.sum(:rec_p), @readingsDay.sum(:rec_m)]
    @ad = [@readingsDay.sum(:ad_p), @readingsDay.sum(:ad_m)]
  end

  def month
    @meter = Meter.find(params[:id])

    if params[:datepicker]
      daterange = params[:daterange].split("to")
      @readings = Reading.where(meter_id: @meter.id).where(date: daterange[0].to_date..daterange[-1].to_date + 1)
    else
      @readings = Reading.where(meter_id: @meter.id)
    end
    
    @readingsMonth = @readings.group_by_month(:date)

    @aec_sum = [@readings.sum(:aec_p), @readings.sum(:aec_m)]
    @rec_sum = [@readings.sum(:rec_p), @readings.sum(:rec_m)]
    @ad_sum = [@readings.sum(:ad_p), @readings.sum(:ad_m)]

    # Generating hashes for sum values
    @aec = [@readingsMonth.sum(:aec_p), @readingsMonth.sum(:aec_m)]
    @rec = [@readingsMonth.sum(:rec_p), @readingsMonth.sum(:rec_m)]
    @ad = [@readingsMonth.sum(:ad_p), @readingsMonth.sum(:ad_m)]
  end

  private def meter_params
    params.require(:meter).permit(:profile, :name, :number, :account, :region_id, :type, :kt, :inverted, :subregion, :account)
  end
end
