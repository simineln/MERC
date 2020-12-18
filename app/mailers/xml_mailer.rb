class XmlMailer < ApplicationMailer

  def ukr_xml_email
    to_send = []
    xml_files = []
    tcode = ""
    @date = params[:date].to_date
    region_id = Region.where(name: "UKRAINA")[0].id
    # @meters = Meter.where(region_id: region_id)
    # meter_ids = [2104, 2107, 2110, 2113, 2116, 2118, 2119, 2121, 2123, 2155, 2177, 2198, 2216, 2254, 2261, 2293, 2299, 2307, 2309, 2311, 2313, 2318, 2323, 2324, 2327, 2328]
    meter_ids = [2307, 2309, 2311, 2313, 2323, 2324, 2327, 2328, 2104, 2107, 2110, 2116, 2118, 2119, 2155, 2254, 2261, 2293, 2299]
    @meters = Meter.where(id: meter_ids)




    sender = "10X1001C--00002V"
    receiver = "10X1001C--00001X"
    md_area = "10Y1001A1001A990"

    tcodes = {
      "MGRES_330VL_Artsiz_lp.xls" => "64T-MDUAMGRSARTV",
      "MGRES_110VL_Starokazacie_lp.xls" => "64T-MDUAMGRSSTRV",
      "MGRES_110VL_Razdelnaia_lp.xls" => "64T-MDUAMGRSRZD8",
      "MGRES_110VL_Beliaevka_lp.xls" => "64T-MDUAMGRSBLV4",
      "MGRES_330VL_NovoOdesskaia_lp.xls" => "64T-MDUAMGRSNODK",
      "MGRES_330VL_Usatovo_lp.xls" => "64T-MDUAMGRSUSTM",
      "Soroca_110_Poroghi.xls" => "64T-MDUA-SRCPRGT",
      "Larga_110_Nelipovtsy.xls" => "64T-MDUALRGNLPTF",
      "Otaci_110_Nemia.xls" => "64T-MDUAOTACNEMX",
      "Ocnitsa_110_Shahty.xls" => "64T-MDUA-OCNSHTA",
      "Beltsi_330_DnGES.xls" => "64T-MDUABALDGESU",
      "Ribnitsa_330_Podolskaia_2.xls" => "64T-MDUARBNPDL2E",
      "Ribnitsa_330_Podolskaia_1.xls" => "64T-MDUARBNPDL1G",
      "PS400_110VL_Bolgrad_1_lp.xls" => "64T-MDUAVLCBLG1X",
      "Etulia_1_35_Nagornaia_lp.xls" => "64T-MDUAETLNGRNG",
      "PS400_110VL_Bolgrad_2_lp.xls" => "64T-MDUAVLCBLG2V",
      "Vasilievka_110_KrOkna.xls" => "64T-MDUAVSLVKROE",
      "PS400_110VL_Bolgrad_3_lp.xls" => "64T-MDUAVLCBLG3T",
      "BSZ_110_DnGES.xls" => "64T-MDUABSZDGES5"
    }


    date_dir = @date.year.to_s + "/" + @date.month.to_s + "/" + @date.day.to_s + "/"
    xml_lib = 'lib/xml/UKRAINA/' + date_dir
    system 'mkdir', '-p', (xml_lib)

    @meters.each_with_index do |meter, index|
      # fname = meter.profile.split('.xls')[0].to_s + '_' + @date.to_s + '.xml'
      fname = @date.strftime("%Y%m%d") + "_SOMA_" + sender + "_" + receiver + "_" + (sprintf '%03d', index + 1) + ".xml"
      readings = Reading.where(meter_id: meter.id).where(date: @date..@date+1).limit(24)

      tcodes.each do |key, value|
        if key == meter.profile.to_s
          tcode = value
        end
      end

      xml = Nokogiri::XML::Builder.new(:encoding => 'utf-8') { |xml|
        xml.MeasurementValueDocument('DtdRelease' => '1', 'DtdVersion' => '0') do
          xml.DocumentIdentification('v' => 'SOMA-' + @date.strftime("%Y%m%d") + '_MD_UA')
          xml.DocumentVersion('v' => "1")
          xml.DocumentType('v' => "A45")
          xml.ProcessType('v' => "A20")
          xml.SenderIdentification('v' => sender, 'codingScheme' => "A01")
          xml.SenderRole('v' => "A04")
          xml.ReceiverIdentification('v' => receiver, 'codingScheme' => "A01")
          xml.ReceiverRole('v' => "A04")
          xml.DocumentDateTime('v' => Time.current.strftime("%Y-%m-%dT%H:%M:%SZ"))
          xml.MeasurementPeriod('v' => @date.to_s + "T00:00Z/" + (@date+1).to_s+"T00:00Z")
          xml.Domain('codingScheme' => 'A01', 'v' => md_area)
          xml.MeasurementTimeSeries do
            xml.SendersTimeSeriesIdentification('v' => 'AP_I_' + tcode)
            xml.BusinessType('v' => "A65")
            xml.Product('v' => "8716867000030")
            xml.InArea('v' => sender, 'codingScheme' => "A01")
            xml.OutArea('v' => receiver, 'codingScheme' => "A01")
            xml.SourcePartyIdentification('v' => sender, 'codingScheme' => "A01")
            xml.MeasurementIdentification('v' => tcode, 'codingScheme' => "A01")
            xml.MeasurementUnit('v' => "MWH")
            xml.Period do
              xml.TimeInterval('v' => @date.to_s + "T00:00Z/" + (@date+1).to_s+"T00:00Z")
              xml.Resolution('v' => "PT60M")
              
              readings.each_with_index do |reading, index|
                xml.Interval do 
                  xml.Pos('v' => index + 1)
                  xml.Qty('v' => reading.ad_p)
                  xml.Qual('v' => "A04")
                end
              end
            end
          end
          xml.MeasurementTimeSeries do
            xml.SendersTimeSeriesIdentification('v' => 'AP_E_' + tcode)
            xml.BusinessType('v' => "A65")
            xml.Product('v' => "8716867000030")
            xml.InArea('v' => sender, 'codingScheme' => "A01")
            xml.OutArea('v' => receiver, 'codingScheme' => "A01")
            xml.SourcePartyIdentification('v' => sender, 'codingScheme' => "A01")
            xml.MeasurementIdentification('v' => tcode, 'codingScheme' => "A01")
            xml.MeasurementUnit('v' => "MWH")
            xml.Period do
              xml.TimeInterval('v' => @date.to_s + "T00:00Z/" + (@date+1).to_s+"T00:00Z")
              xml.Resolution('v' => "PT60M")
              
              readings.each_with_index do |reading, index|
                xml.Interval do 
                  xml.Pos('v' => index + 1)
                  xml.Qty('v' => reading.ad_m)
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
    # mail(to: "svnik@moldelectrica.md", subject: "Test XML profiles from MERC, date: " + @date.to_s)
    # mail(to: "simineln@yandex.ru", subject: "Test XML profiles from MERC, date: " + @date.to_s)
    #mail(to: "siminel.n@gmail.com", subject: "Test XML profiles from MERC, date: " + @date.to_s)

  end


  def cet_json_email
    @date = params[:date].to_date
    @meters = Meter.where(subregion: "CET_2")

    date_dir = @date.year.to_s + "/" + @date.month.to_s + "/" + @date.day.to_s + "/"
    json_lib = 'lib/json/CET_2/' + date_dir
    system 'mkdir', '-p', (json_lib)


    @meters.each_with_index do |meter, index|
      fname = meter.profile.split('.xls')[0].to_s + '_' + @date.to_s + '.json'
      @readings = Reading.where(meter_id: meter.id).where(date: @date..@date+1).limit(24)

      mail(to: "siminel.n@gmail.com", subject: "Test JSON profiles from MERC, date: " + @date.to_s)

    end



  end
end
