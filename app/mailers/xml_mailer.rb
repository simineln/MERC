class XmlMailer < ApplicationMailer

  def ukr_xml_email
    to_send = []
    xml_files = []
    @date = params[:date].to_date
    region_id = Region.where(name: "UKRAINA")[0].id
    # @meters = Meter.where(region_id: region_id)
    meter_ids = [2104, 2107, 2110, 2113, 2116, 2118, 2119, 2121, 2123, 2155, 2177, 2198, 2216, 2254, 2261, 2293, 2299, 2307, 2309, 2311, 2313, 2318, 2323, 2324, 2327, 2328]
    @meters = Meter.where(id: meter_ids)



    date_dir = @date.year.to_s + "/" + @date.month.to_s + "/" + @date.day.to_s + "/"
    xml_lib = 'lib/xml/UKRAINA/' + date_dir
    system 'mkdir', '-p', (xml_lib)

    @meters.each do |meter|
      fname = meter.profile.split('.xls')[0].to_s + '_' + @date.to_s + '.xml'
      readings = Reading.where(meter_id: meter.id).where(date: @date..@date+1).limit(24)

      xml = Nokogiri::XML::Builder.new(:encoding => 'utf-8') { |xml|
        xml.MeasurementValueDocument('DtdRelease' => '1', 'DtdVersion' => '0') do
          xml.DocumentIdentification('v' => 'MERC_DOC_54')
          xml.DocumentVersion('v' => "1")
          xml.DocumentType('v' => "A45")
          xml.ProcessType('v' => "A20")
          xml.SenderIdentification('v' => "test_admin", 'codingScheme' => "A01")
          xml.SenderRole('v' => "A04")
          xml.ReceiverIdentification('v' => "moldelectrica_test", 'codingScheme' => "A01")
          xml.ReceiverRole('v' => "A04")
          xml.DocumentDateTime('v' => Time.current)
          xml.MeasurementPeriod('v' => @date.to_s + "/" + (@date+1).to_s)
          xml.MeasurementTimeSeries do
            xml.SendersTimeSeriesIdentification('v' => 'Zcode')
            xml.BusinessType('v' => "A65")
            xml.Product('v' => "8716867000030")
            xml.InArea('v' => "test_area1", 'codingScheme' => "A01")
            xml.OutArea('v' => "test_area2", 'codingScheme' => "A01")
            xml.SourcePartyIdentification('v' => "test", 'codingScheme' => "A01")
            xml.MeasurementIdentification('v' => "test_Zcode", 'codingScheme' => "A01")
            xml.MeasurementUnit('v' => "kWH")
            xml.Period do
              xml.TimeInterval('v' => @date.to_s + "T00:00Z/" + (@date+1).to_s+"T00:00Z")
              xml.Resolution(v="PT1H")
              
              readings.each_with_index do |reading, index|
                xml.Interval do 
                  xml.Pos('v' => index + 1)
                  xml.Qty('v' => reading.aec_p)
                  xml.Qual('v' => "A04")
                end
              end
            end
          end
        end
      }.to_xml

      xml_fname = xml_lib + fname
      xml_files.append(fname)
      to_send.append(xml_fname)
      File.open(xml_fname, 'w') { |f| f.write(xml) }
    end

    to_send.each_with_index do |path_to_file, index|
      attachments[xml_files[index]] = File.read(path_to_file)
    end

    mail(to: "siminel.n@gmail.com", subject: "Test XML profiles from MERC, date: " + @date.to_s)
    # mail(to: "simineln@yandex.ru", subject: "Test XML profiles from MERC, date: " + @date.to_s)
    #mail(to: "siminel.n@gmail.com", subject: "Test XML profiles from MERC, date: " + @date.to_s)

  end
end
