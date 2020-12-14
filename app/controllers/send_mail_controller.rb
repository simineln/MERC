class SendMailController < ApplicationController
  def index

    region_id = Region.where(name: "UKRAINA")[0].id
    # @meters = Meter.where(region_id: region_id)
    meter_ids = [2104, 2107, 2110, 2113, 2116, 2118, 2119, 2121, 2123, 2155, 2177, 2198, 2216, 2254, 2261, 2293, 2299, 2307, 2309, 2311, 2313, 2318, 2323, 2324, 2327, 2328]
    @meters = Meter.where(id: meter_ids)


    if params[:send]
      if params[:datepicker] == nil
        flash[:alert] = 'Для отправки XML выберите дату'
      else
        date = params[:daterange]
        XmlMailer.with(date: date).ukr_xml_email.deliver_later
        flash[:notice] = 'XML отправлен партнёру - ' + "UKRAINA"
      end
    end

  end
end
