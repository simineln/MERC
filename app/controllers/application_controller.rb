class ApplicationController < ActionController::Base
  before_action :authenticate_user!, :nav, :reading_init#, :meter_init

  def nav
    @regions = Region.order(:name)
  end

  def meter_init
    lib_dir = 'lib/2020/'
    regions = Region.all

    months = Dir.glob("#{lib_dir}*/").sort
    months.each do |month|
      days = Dir.glob("#{month}*/").sort
      days.each do |day|

        profiles = Dir.glob("#{days[0]}**/*.xls")
        profiles.each do |profile|
          xls = Roo::Spreadsheet.open(profile)
          profile_name = profile.split("/")[-1]
          meter_num = xls.sheet('Report').row(9)[2].to_i
          meter_name = xls.sheet('Report').row(10)[2].to_s
          account = xls.sheet('Report').row(4)[2].to_s
          kt = 3000
          format = 1
          inverted = false

          regions.each do |region|
            if profile.upcase.include? region.name
              @region_id = region.id.to_i

              @subregion = profile.split(day+region.name)[-1].split("/")[1]
              if @subregion.include? ".xls" or @subregion == "2020"
                @subregion = ""
              end
              break
            end
          end

          meter = Meter.new(profile: profile_name, name: meter_name, number: meter_num, account: account, region_id: @region_id, format: format, kt: kt, inverted: inverted, subregion: @subregion)
          meter.save
        end
      end
    end
  end

  def reading_init
    lib_dir = 'lib/2020/'

    readings = Reading.all
    @processed_dates = []
    readings.each do |reading|
      year = reading.date.year.to_s
      month = reading.date.month.to_s
      day = reading.date.day.to_s
      @processed_dates.append("#{day}/#{month}/2020")
    end

    @processed_dates = @processed_dates.uniq

    date_col = []
    months = Dir.glob("#{lib_dir}*/").sort
    months.each do |month|
      days = Dir.glob("#{month}*/").sort
      days.each do |day|

        current_date = "#{day.split('/')[-1].to_i}/#{month.split('/')[-1].to_i}/2020"
        next if @processed_dates.include? current_date

        profiles = Dir.glob("#{day}**/*.xls")
        profiles.each do |profile|

          xls = Roo::Spreadsheet.open(profile)
          meter_num = xls.sheet('Report').row(9)[2].to_i
          @meter = Meter.where(number: meter_num)[0]
          date_col = xls.sheet('Report').column(2)

          column_num = xls.sheet('Report').last_column.to_i
          name_row = xls.sheet('Report').row(11)

          flag = Array.new(17, false)
          
          for i in 1..column_num
            name_row.each_with_index do |x, index|
              case x
                when "AD+"
                  @ad_p_col = xls.sheet('Report').column(index + 1)
                  flag[0] = true
                when "AD-"
                  @ad_m_col = xls.sheet('Report').column(index + 1)
                  flag[1] = true
                when "RD+"
                  @rd_p_col = xls.sheet('Report').column(index + 1)
                  flag[2] = true
                when "RD-"
                  @rd_m_col = xls.sheet('Report').column(index + 1)
                  flag[3] = true
                when "AEC+"
                  @aec_p_col = xls.sheet('Report').column(index + 1)
                  flag[4] = true
                when "AEC-"
                  @aec_m_col = xls.sheet('Report').column(index + 1)
                  flag[5] = true
                when "REC+"
                  @rec_p_col = xls.sheet('Report').column(index + 1)
                  flag[6] = true
                when "REC-"
                  @rec_m_col = xls.sheet('Report').column(index + 1)
                  flag[7] = true
                when "Vph1"
                  @vph1_col = xls.sheet('Report').column(index + 1)
                  flag[8] = true
                when "Vph2"
                  @vph2_col = xls.sheet('Report').column(index + 1)
                  flag[9] = true
                when "Vph3"
                  @vph3_col = xls.sheet('Report').column(index + 1)
                  flag[10] = true
                when "Iph1"
                  @iph1_col = xls.sheet('Report').column(index + 1)
                  flag[11] = true
                when "Iph2"
                  @iph2_col = xls.sheet('Report').column(index + 1)
                  flag[12] = true
                when "Iph3"
                  @iph3_col = xls.sheet('Report').column(index + 1)
                  flag[13] = true
                when "cosPHI"
                  @cosPHU_col = xls.sheet('Report').column(index + 1)
                  flag[14] = true
                when "THD_U"
                  @thd_u_col = xls.sheet('Report').column(index + 1)
                  flag[15] = true
                when "THD_I"
                  @thd_i_col = xls.sheet('Report').column(index + 1)
                  flag[16] = true
              end
            end
          end

          rows = ([13] + (16..108).step(4).to_a).each_cons(2).to_a # row numbers 13..16..108 splitting by pairs
          rows.each do |row|
            date = date_col[row[1] - 1]

            flag[0] ? ad_p = (@ad_p_col[row[1] - 1]).round(4) : ad_p = 0
            flag[1] ? ad_m = (@ad_m_col[row[1] - 1]).round(4) : ad_m = 0
            flag[2] ? rd_p = (@rd_p_col[row[1] - 1]).round(4) : rd_p = 0
            flag[3] ? rd_m = (@rd_m_col[row[1] - 1]).round(4) : rd_m = 0
            
            flag[4] ? aec_p = ((@aec_p_col[row[1] - 1] - @aec_p_col[row[0] - 1]) * @meter.kt).round(4) : aec_p = 0
            flag[5] ? aec_m = ((@aec_m_col[row[1] - 1] - @aec_m_col[row[0] - 1]) * @meter.kt).round(4) : aec_m = 0
            flag[6] ? rec_p = ((@rec_p_col[row[1] - 1] - @rec_p_col[row[0] - 1]) * @meter.kt).round(4) : rec_p = 0
            flag[7] ? rec_m = ((@rec_m_col[row[1] - 1] - @rec_m_col[row[0] - 1]) * @meter.kt).round(4) : rec_m = 0
            
            flag[8] ? vph1 = (@vph1_col[row[1] - 1]).round(4) : vph1 = 0
            flag[9] ? vph2 = (@vph2_col[row[1] - 1]).round(4) : vph2 = 0
            flag[10] ? vph3 = (@vph3_col[row[1] - 1]).round(4) : vph3 = 0
            flag[11] ? iph1 = (@iph1_col[row[1] - 1]).round(4) : iph1 = 0
            flag[12] ? iph2 = (@iph2_col[row[1] - 1]).round(4) : iph2 = 0
            flag[13] ? iph3 = (@iph3_col[row[1] - 1]).round(4) : iph3 = 0
            flag[14] ? cosPHU = (@cosPHU_col[row[1] - 1]).round(4) : cosPHU = 0
            flag[15] ? thd_u = (@thd_u_col[row[1] - 1]).round(4) : thd_u = 0
            flag[16] ? thd_i = (@thd_i_col[row[1] - 1]).round(4) : thd_i = 0

            readings = Reading.new(meter_id: @meter.id, date: date, ad_p: ad_p, ad_m: ad_m, rd_p: rd_p, rd_m: rd_m, aec_p: aec_p, aec_m: aec_m, rec_p: rec_p, rec_m: rec_m, vph1: vph1, vph2: vph2, vph3: vph3, iph1: iph1, iph2: iph2, iph3: iph3, cosPHI: cosPHU, THD_U: thd_u, THD_I: thd_i)
            # readings.save

            if readings.save
              flash[:notice] = 'Профиль добавлен'
            end


          end
        end #profiles
      end #days
    end #months
  end

end
