load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
begin

    wks   = gsn_open_wks ("x11", "DMI_obs" )
    data_dir    = "/home/ys17-19/data-observation/SST/HadISST/"
    obs_or_mod  =   "obs"
    var         =   "sst"
    start_year  =   1979
    end_year    =   2017
    ref_year    =   1979
    fi_name1    =   "HadISST_sst_18702018.nc"
    fi_name     =   (/fi_name1/)
    main_title  =   (/"HadISST"/)
    ;fi_name2    =   "Hurrell2008_1870-2012_sst.nc"
    ;fi_name3    =   "noaa_oi_v2_1982-2012_sst_dble.nc"
    ;fi_name4    =   "ERSST_v3b_1870-2012_sst.nc"
    ;fi_name     =   (/fi_name1,fi_name2,fi_name4/)
    ;main_title  =   (/"HadISST","Hurrell2008","ERSST_v3b"/)
    xaxis_title =   (/"    ","    ","year"/)
    plot = new(dimsizes(fi_name),graphic)

    num_time    =   (end_year-start_year+1)*12
    yyyymm      =   new(num_time,integer)

    do year     = start_year, end_year
    do month    = 1, 12
        y_m_i   =   (year-start_year)*12+month-1
        yyyymm(y_m_i)   =   year*100+month
    end do
    end do
    yefrac = yyyymm_to_yyyyfrac(yyyymm, 0.5)
    start_ind   =   (start_year-ref_year)*12
    end_ind     =   (end_year-ref_year)*12+11

    do fi_ind   =   0, dimsizes(fi_name)-1
        fi_long_name=   data_dir+fi_name(fi_ind)
        fi          =   addfile(fi_long_name,"r")

        sst         =   rmMonAnnCycTLL(fi->sst(start_ind:end_ind,:,:))
        lon  =   dble2flt(fi->longitude)
        lat  =   dble2flt(fi->latitude)
        dlon =   abs(lon(1) - lon(0))
        dlat =   abs(lat(1) - lat(0))
        num_lon =   dimsizes(lon)
        num_lat =   dimsizes(lat)
        area_wgt    =   new((/num_lat,num_lon/),float)
        dx  =   new(num_lat,float)
        dy  =   new(num_lat,float)
        re  =   6.371e6
        rad =   4.0*atan(1.0)/180.0
        do j = 1-1, num_lat-1
            dx(j)   =   doubletofloat(re*cos(lat(j)*rad)*dlon*rad)
            dy(j)   =   doubletofloat(re*abs(dlat)*rad)
        end do
        do j = 1-1, num_lat-1
        do i = 1-1, num_lon-1
            area_wgt(j,i)   =   dx(j)*dy(j)
        end do
        end do
        area_wgt!0  =   "lat"
        area_wgt!1  =   "lon"
        area_wgt&lat    =   lat
        area_wgt&lon    =   lon
        print("area check")
        print("max of area: " + max(area_wgt))
        print("min of area: " + min(area_wgt))
        print("total area : " + sum(area_wgt))


        lons    =   50.0
        lone    =   70.0
        lats    =   -10.0
        late    =   10.0
        w_sst   =   wgt_areaave2(sst(:,{lats:late},{lons:lone}),area_wgt({lats:late},{lons:lone}),0)

        lons    =   90.0
        lone    =   110.0
        lats    =   -10.0
        late    =   0.0
        e_sst   =   wgt_areaave2(sst(:,{lats:late},{lons:lone}),area_wgt({lats:late},{lons:lone}),0)

        dmi     =   w_sst-e_sst
        print(dmi)
        nave = 5
        opt = -1
        dmi_runave  = runave (dmi, nave, opt)  ; return the series in the original array
        
        stats=dim_stat4(dmi)
        print("Standard Deviation of DMI: "+dim_stddev(dmi))
        print("Standard Deviation of 5-point runave DMI: "+dim_stddev(dmi_runave))
        print("stats: "+stats)

        res   = True

        ; these four resources allow the user to stretch the plot size, and
        ; decide exactly where on the page to draw it.

        ;res@vpXF      = 0.80        ; In page coordinates, where to start
        ;res@vpYF      = 0.45        ; the plot
        res@gsnMaximize     =   True
        res@gsnDraw         =   False
        res@gsnFrame        =   False
        res@vpHeightF = 0.25        ; Changes the aspect ratio
        res@vpWidthF  = 0.85

        res@trYMinF   = -1.5        ; min value on y-axis
        res@trYMaxF   =  1.5        ; max value on y-axis
        res@trXMinF   = 1869        ; min value on y-axis
        res@trXMaxF   = 2005        ; max value on y-axis

        ;res@tiYAxisString = "Anomalies" ; y-axis label      
        ;res@tiMainString  = "Darwin Southern Oscillation Index" ; title

        res@gsnYRefLine           = 0.              ; reference line   
        ;res@gsnXYBarChart         = True            ; create bar chart
        res@gsnAboveYRefLineColor = "red"           ; above ref line fill red
        res@gsnBelowYRefLineColor = "blue"          ; below ref line fill blue

        res@tiMainString    =   main_title(fi_ind)
        res@tiXAxisString   =   "year"
        res@tiYAxisString   =   ""
        res@gsnLeftString   =   "units: ~F34~0~F~C"
        res@gsnRightString  =   "SD: "+sprintf("%4.2f",dim_stddev(dmi))
        res@gsnCenterString =   ""

        res@tiMainFontHeightF   =   0.025
        res@tiXAxisFontHeightF  =   0.022
        res@tiYAxisFontHeightF  =   0.02
        res@gsnLeftStringFontHeightF    =   0.02
        res@gsnRightStringFontHeightF   =   0.02
        res@gsnCenterStringFontHeightF  =   0.02
        res@tmYLLabelFontHeightF    =   0.02
        res@tmXBLabelFontHeightF    =   0.02

        plot(fi_ind) = gsn_csm_xy (wks,yefrac,dmi,res)
        ;draw(plot)
        ;frame(wks)
        delete(sst)
        delete(lon)
        delete(lat)
        delete(area_wgt)
        delete(dx)
        delete(dy)
    end do

    ;resP    =   True
    ;resP@gsnMaximize     =   True
    ;resP@gsnPaperOrientation = "portrait"
    ;gsn_panel(wks,plot,(/3,1/),resP)

end
