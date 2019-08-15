begin

    l_thick= 2
    range=6
    ;Fig region
    g_figlatS=-30
    g_figlatN=50
    g_figlonE=30
    g_figlonW=300

    ;Nino 3
    g_latS=-5.
    g_latN=5.
    g_lonW=190.
    g_lonE=240.

    
    g_font = 0.018

    g_strt_date = 19790301 
    g_lst_date = 19790531
    year = 37
    date = year * (31 + 30 + 31)
    point = 4
    print(date)
    outfile    = "/home/ys17-19/cjx/all_output_data/PCOR/smooth_daily/olr_MAM_1979_2016.nc"

;*************************For F_Compset Ctrl***********************************

; ==============================================================
; Mission 1. Open the file: Read only the user specified period
; ==============================================================

;input_data = addfile("/home/ys17-19/data-observation/ERA-interim/pressure/hgt/hgt.interim.1979.nc","r") hgt; time
data_olr = addfile("/home/ys17-19/data-observation/NOAA-OLR/daily/olr.day.mean.nc","r")
time_olr = data_olr->time
yyyymmdd_olr = cd_calendar(time_olr,-2)
var = short2flt(data_olr->olr(:,:,:))
olr = new((/date,73,144/), float, "No_FillValue")
olr_smooth = new((/date/point,73,144/), float, "No_FillValue")
;copy_VarCoords(var, olr)

    do i = 0, year-1, 1
    g_strt_date = g_strt_date + 10000
    g_lst_date  = g_lst_date  + 10000
    ;print(g_lst_date)
    istrt_olr   = ind(yyyymmdd_olr .eq. g_strt_date)
    ilast_olr   = ind(yyyymmdd_olr .eq. g_lst_date)
    olr(92*i:92*i+91, :, :) = short2flt(data_olr->olr(istrt_olr:ilast_olr,:,:))
    end do
    
    do i=0 , date/point-1, 1
    olr_smooth(i, :, :) = dim_avg_n_Wrap(olr(point*i:point*i+point-1,:,:),0)
    ;print(i)
    end do

    olr_smooth!0 = "time"
    printVarSummary(olr_smooth)

    system("rm -rf " + outfile)
    output_data = addfile(outfile,"c")
    output_data->olr_smooth = olr_smooth

end
