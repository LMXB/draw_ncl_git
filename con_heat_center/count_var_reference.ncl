;================================================;
;  maponly_3.ncl
;================================================;
;
; Concepts illustrated:
;   - Changing the color of the oceans, land, and inland water areas
;
;=================================================;
;
; These files are loaded by default in NCL V6.2.0 and newer
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"   
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"   
;=================================================;
begin

    g_data_path ="/home/ys17-19/data-observation/PREC/GPCP_precip.mon.mean.nc"
    g_strt_mon = 197901 
    g_lst_mon = 201412
    g_season= "MAM"
	ctrl_file1   = g_data_path
	ctrl_in1     = addfile (ctrl_file1, "r")   ; note the "s" of addfile
	time_hist    = ctrl_in1->time
    yyyymm  = cd_calendar(time_hist,-1)
    istrt   = ind(yyyymm .eq. g_strt_mon)
    ilast   = ind(yyyymm .eq. g_lst_mon)
	var  =ctrl_in1->precip(istrt:ilast,:,:)			; p for unify the var name

    var_ssn = month_to_season(var,g_season)

    var_ssn_mean=dim_avg_n_Wrap(var_ssn,0)

    printVarSummary(var_ssn_mean)

    ; spring
    lon_array=(/10.0, 115.0, 140.0, 155.0, 231.0,  284.0, 310.0/)
    lat_array=(/0.0,  0.0,   -5.0,  5.0,   5.0,    0.0,   0.0/)

    ; summer
    ;lon_array=(/90.0, 140.0, 250.0, 295.0, 345.0,  10.0/)
    ;lat_array=(/20.0, 5.0,   10.0,  5.0,   10.0,  5.0/)
    
    ; winter
    ;lon_array=(/110.0, 140.0,  175.0, 300.0,  47.5/)
    ;lat_array=(/0.0,   -5.0,   -10.0, -7.5,   -17.5/)
    
    ; autumn
    ;lon_array=(/100.0, 140.0,  220.0, 280.0,  330.0, 10.0/)
    ;lat_array=(/0.0,   -5.0,   7.5,   5.0,    7.5,   0.0/)
    

    dimlon=dimsizes(lon_array) 

    total=0.0
    do ii=0,dimlon-1
       total= total+var_ssn_mean({lat | lat_array(ii)},{lon | lon_array(ii)})
    end do
    print(total)

    var_reference=new((/dimlon/),float)
    do ii=0,dimlon-1
       ; plot@$unique_string("fxxk ncl")$    = gsn_add_polymarker(wks,plot,lon_array(ii),lat_array(ii),polyres)
       ;var_reference(ii)=var_reference(ii)+var_ssn({lat | lat_array(ii)},{lon | lon_array(ii)},time|:)*var_ssn_mean({lat | lat_array(ii)},{lon | lon_array(ii)})/total
        print("lon="+lon_array(ii)+" lat="+lat_array(ii) +" proportion="+var_ssn_mean({lat | lat_array(ii)},{lon | lon_array(ii)})/total )
    end do

    print("end counting var_reference")
end
