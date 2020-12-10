class ReportsController < ApplicationController
  

  def index


    if params[:datepicker]
      @meters = [
        Meter.where(profile: "CET_2_110VL_Naberejnaya_1_lp.xls"),
        Meter.where(profile: "CET_2_110VL_Kishinevskaya_lp.xls"),
        Meter.where(profile: "CET_2_110VL_Dubossary_lp.xls"),
        Meter.where(profile: "CET_2_110VL_Munceshty_lp.xls"),
        Meter.where(profile: "CET_2_110VL_Zavodskaya_lp.xls"),
        Meter.where(profile: "CET_2_110VL_Naberejnaya_2_lp.xls"),
        Meter.where(profile: "CET_2_110VL_CET_1_lp.xls"),
        Meter.where(profile: "CET_2_110VL_Strasheny_lp.xls"),
        Meter.where(profile: "CET_2_110VL_Kompex_lp.xls"),
        Meter.where(profile: "CET_2_110VL_Ryshkanovka_lp.xls"),
        Meter.where(profile: "CET_2_110VL_Cricova_lp.xls"),
        Meter.where(profile: "CET_2_110VSHO_A_lp.xls"),
        Meter.where(profile: "CET_2_110VSHO_B_lp.xls")
      ]

      @daterange = params[:daterange].to_date
      @readings = [
        Reading.where(meter_id: @meters[0][0].id).where(date: @daterange..@daterange+1).limit(24),
        Reading.where(meter_id: @meters[1][0].id).where(date: @daterange..@daterange+1).limit(24),
        Reading.where(meter_id: @meters[2][0].id).where(date: @daterange..@daterange+1).limit(24),
        Reading.where(meter_id: @meters[3][0].id).where(date: @daterange..@daterange+1).limit(24),
        Reading.where(meter_id: @meters[4][0].id).where(date: @daterange..@daterange+1).limit(24),
        Reading.where(meter_id: @meters[5][0].id).where(date: @daterange..@daterange+1).limit(24),
        Reading.where(meter_id: @meters[6][0].id).where(date: @daterange..@daterange+1).limit(24),
        Reading.where(meter_id: @meters[7][0].id).where(date: @daterange..@daterange+1).limit(24),
        Reading.where(meter_id: @meters[8][0].id).where(date: @daterange..@daterange+1).limit(24),
        Reading.where(meter_id: @meters[9][0].id).where(date: @daterange..@daterange+1).limit(24),
        Reading.where(meter_id: @meters[10][0].id).where(date: @daterange..@daterange+1).limit(24),
        Reading.where(meter_id: @meters[11][0].id).where(date: @daterange..@daterange+1).limit(24),
        Reading.where(meter_id: @meters[12][0].id).where(date: @daterange..@daterange+1).limit(24)
        ]

        @peretoki = []


        for i in 0..23
          var = 0
          for j in 0..10
            var += @readings[j][i].ad_m - @readings[j][i].ad_p
          end
          @peretoki.append(var.round(2))
        end

    end


  end


  def show
  end
end
