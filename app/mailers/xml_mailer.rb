class XmlMailer < ApplicationMailer

  def new_xml_email
    @meter = params[:meter]
    @date = "2020-09-06".to_date
    @readings = Reading.where(meter_id: @meter.id).where(date: @date..@date+1).limit(24)
    # @readings = params[:readings]
    # @meter = Meter.where(id: @readings[0].meter_id)


    mail(to: "siminel.n@gmail.com", subject: "Test XML file from MERC!")
    # mail(to: "ansi@inbox.ru", subject: "Test email from MERC!")

  end
end
