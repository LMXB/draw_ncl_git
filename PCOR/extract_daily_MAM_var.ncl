begin

    g_strt_date = 19790301 
    g_lst_date = 19790531
    year = 37
    date = year * (31 + 30 + 31)
    point = 4
    level = (/150,175,200,225,250,300,400,500,700,850,925,1000/)
;*************************For F_Compset Ctrl***********************************

; ==============================================================
; Mission 1. Open the file: Read only the user specified period
; ==============================================================

var_name = (/"hgt", "air", "uwnd","vwnd"/)
do j=3, 3, 1
    outfile    = "/home/ys17-19/cjx/all_output_data/PCOR/smooth_daily/"+var_name(j)+"_MAM_1979_2016.nc"
    input_path = "/home/yangsong3/data-observation/ERA-interim/pressure/"+var_name(j)+"/"+var_name(j)+".interim.*.nc" 
    ;input_path = "/home/yangsong3/data-observation/ERA-interim/pressure/hgt/hgt.interim.*.nc" 
    fils := systemfunc("ls "+input_path) 
    print(fils)
    setfileoption("nc","SuppressClose",False) ; close too many files
    input_data = addfiles(fils,"r")
    ListSetType(input_data,"cat")
    
    time_var = input_data[:]->time
    yyyymmdd_var = cd_calendar(time_var,-2)
    delete(time_var)
    var_in = input_data[:]->$var_name(j)$(:,{level},:,:)
    ;var_raw = input_data[:]->$var_name(j)$
    ;var_in = var_raw(:,{level},:,:)
    printVarSummary(var_in)
    
    var = new((/date,dimsizes(level),121,240/), float, "No_FillValue")
    var_smooth = new((/date/point,dimsizes(level),121,240/), float, "No_FillValue")
    
        do i = 0, year-1, 1
            g_strt_date = g_strt_date + 10000
            g_lst_date  = g_lst_date  + 10000
            ;print(g_lst_date)
            istrt_var   = ind(yyyymmdd_var .eq. g_strt_date)
            ilast_var   = ind(yyyymmdd_var .eq. g_lst_date)
            var(92*i:92*i+91, :, :, :) = var_in(istrt_var:ilast_var,:,:,:)
        end do
        
        do i=0 , date/point-1, 1
            var_smooth(i, :, :, :) = dim_avg_n_Wrap(var(point*i:point*i+point-1,:,:,:),0)
            ;print(i)
        end do
    
   var_smooth!0 = "time"
   printVarSummary(var_smooth)
   
   system("rm -rf " + outfile)
   setfileoption("nc","Format","LargeFile") ; close too many files
   output_data = addfile(outfile,"c")
   output_data->var_smooth = var_smooth
   print("finish "+ var_name(j))
end do
end
