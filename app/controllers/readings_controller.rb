class ReadingsController < ApplicationController
  def edit
    @reading = Reading.find(params[:id])
    @meter = Meter.where(id: @reading.meter_id)
  end

  def update
    @reading = Reading.find(params[:id])
    @meter = Meter.where(id: @reading.meter_id)

    if @reading.update(reading_params)
      flash[:notice] = 'Счётчик изменён/заменён'
      redirect_to hour_meter_path(@meter)
    end
  end

  private def reading_params
    params.require(:reading).permit(:meter_id, :date, :ad_p, :ad_m, :rd_p, :rd_m, :aec_p, :aec_m, :rec_p, :rec_m, :vph1, :vph2, :vph3, :iph1, :iph2, :iph3, :cosPHI, :THD_U, :THD_I)
  end
end
