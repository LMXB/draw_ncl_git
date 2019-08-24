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
;=================================================
begin

;part1 define the parameter

    g_data_path ="/home/ys17-19/cjx/observation_data/gpcp_v02r03_monthly_197901_201901.nc"
    outfile ="/home/ys17-19/cjx/figure/obs_precip_center"
    g_font=0.02
    g_range=26.25
    g_latS=-g_range
    g_latN=g_range
    grid = 2.5
    g_strt_mon = 197901 
    g_lst_mon = 201812
    year=ispan(1979,2018,1)
    g_season= (/"MAM", "JJA", "SON", "DJF"/)
    g_label = (/"(a)","(b)","(c)","(d)"/)
    plot = new((/8/),graphic)
    lat_location = new((/4/),float,"No_FillValue")
    lon_location = new((/4/),float,"No_FillValue")

;part2: input data
	ctrl_file1   = g_data_path
	ctrl_in1     = addfile (ctrl_file1, "r")   ; note the "s" of addfile
	time_hist    = ctrl_in1->time
    yyyymm  = cd_calendar(time_hist,-1)
    istrt   = ind(yyyymm .eq. g_strt_mon)
    ilast   = ind(yyyymm .eq. g_lst_mon)
	var  =ctrl_in1->precip(istrt:ilast,:,:)			; p for unify the var name
    printVarSummary(var)

;part3: make constant plot setting 
    wks  = gsn_open_wks("x11",outfile)      ; send graphics to PNG file
    gsn_define_colormap(wks,"precip2_17lev")
    res                        = True         ; mods desired   
    res@cnFillOn             = True               ; turn on color for contours
    res@cnLinesOn            = False              ; turn off contour lines
    res@cnLineLabelsOn       = False              ; turn off contour line labels
    res@cnLevelSelectionMode  = "ManualLevels" ; set manual contour levels
    res@cnMinLevelValF        = 4.         ; set min contour level
    res@cnMaxLevelValF        = 12.          ; set max contour level
    res@cnLevelSpacingF       = 1.          ; set contour interval

    ;res@cnFillColors =(/2,4,7,8,8,9,11,13/)
    ;res@cnFillColors    =(/15,14,13,11,9,8,7,4,3,2/)
    res@cnFillColors    =(/2,3,4,7,8,9,11,13,14,15/)

    res@gsnFrame         = False
    res@gsnDraw  = False

    res@gsnSpreadColors      = True               ; use full color map
    res@gsnSpreadColorStart  = 2               ; start at color 17
    res@gsnSpreadColorEnd    = 14                ; end at color 200

    ;  res@gsnPanelLabelBar    = True   ;Turn on panel labelbar
    res@gsnStringFontHeightF = g_font

    res@gsnMaximize      = True       ; fill up the page
    res@gsnAddCyclic   = True;False
    res@gsnPaperOrientation = "portrait"

    res@lbLabelBarOn = False   ; turn off the label bar
    res@lbOrientation          = "vertical"
    res@lbLabelFontHeightF  = g_font              ; make labels smaller
    res@lbLabelStride = 2 

    res@mpFillOn   = False     ; turn off gray continents
    res@mpGeophysicalLineThicknessF = 1.
    res@mpGeophysicalLineColor      = "black";"white"
    res@mpFillDrawOrder="PreDraw"
    res@mpCenterLonF = 180.
    res@mpMaxLatF  = g_latN
    res@mpMinLatF  = g_latS
;    res@mpMaxLonF  = g_lonE
;    res@mpMinLonF  = g_lonW

    ;  res@mpShapeMode = "FreeAspect" 

    ;  res@vpWidthF = 0.8
    ;  res@vpHeightF = 0.6

    ;  res@tmXBMajorOutwardLengthF = -0.
    ;  res@tmYLMajorOutwardLengthF = -0.
    ;  res@tmYRMajorOutwardLengthF = -0.

    ;  res@tmXBMinorOutwardLengthF = -0.
    ;  res@tmYLMinorOutwardLengthF = -0.
    ;  res@tmYRMinorOutwardLengthF = -0.

     ; now change the size of the tickmark labels
    res@tmXBTickSpacingF = 60 
    res@tmYLTickSpacingF = 15
    res@tmXBLabelFontHeightF = g_font
    ; res@tmXBLabelFontAspectF = 1.6
    res@tmXBLabelFontThicknessF = 2.0
    res@tmYLLabelFontHeightF = g_font
    res@tmXBLabelDeltaF      =-0.8
    ; res@tmYLLabelFontAspectF = 1.3
    res@tmYLLabelFontThicknessF = 2.0
    ; res@tmYLLabelFontQuality =
    ;-----------------------------------------------------------------------------
     
    res@gsnRightString = ""    
    ;res@vpHeightF        = 0.05
    ;res@vpWidthF         = 0.8

    polyres                   = True
    polyres@gsMarkerIndex     = 2          ; polymarker style
    polyres@gsMarkerSizeF     = 12.          ; polymarker size
    polyres@gsMarkerThicknessF     = 6.          ; polymarker size
    polyres@gsMarkerColor     = "black"          ; polymarker size

    xyres                  = True
    xyres@gsnFrame         = False
    xyres@gsnDraw          = False
    xyres@vpHeightF        = 0.148
    xyres@vpWidthF         = 0.8
    xyres@gsnRightString   = " "    
    xyres@gsnLeftString    = " "    
    xyres@tiXAxisOn        = False
    xyres@tmYRLabelsOn     = False
    xyres@tiYAxisString    = ""
    xyres@trXMinF          = min(year)
    xyres@trXMaxF          = max(year)
    xyres@tmXMinorGrid     = False
    xyres@tmYMinorGrid     = False
    xyres@tmYMajorGrid     = False
    xyres@tmXBMajorLengthF = 0.
    xyres@tmYLMajorLengthF = 0.
    xyres@tmYLMinorLengthF = 0.
    xyres@tmYLMinorLengthF = 0.
    xyres@tmYLMode         = "Manual"
    xyres@tmYLTickStartF   = 160.
    xyres@tmYLTickEndF     = 210.
    xyres@tmYLTickSpacingF = 10.
    xyres@tmXBLabelFontHeightF = g_font
    xyres@tmXBLabelDeltaF      =-0.8
    xyres@tiMainOn         = True
    xyres@tiMainFontHeightF= 0.022
    xyres@tiMainOffsetYF   = -0.01
    ;xyres@tmXBMajorOutwardLengthF = 0.
    ;xyres@tmYLMajorOutwardLengthF = 0.
    ;xyres@tmYRMajorOutwardLengthF = 0.

start = 2
;part4: draw in cycle
    do i=0,3,1
        var_ssn = month_to_season(var(time|:,{latitude | g_range:-g_range},longitude |:),g_season(i))
        var_ssn_mean = dim_avg_n_Wrap(var_ssn,0)
        ;var_ssn_mean = dim_avg_n_Wrap(var(time|:,{lat | g_range:-g_range},lon |:),0)
        var_ssn_area = new((/dimsizes(var_ssn_mean&latitude), dimsizes(var_ssn_mean&longitude)/), float, 32766)
        copy_VarCoords(var_ssn_mean, var_ssn_area)

            do i_lat=start, dimsizes(var_ssn_mean&latitude)-1-start, 1
                do i_lon=start, dimsizes(var_ssn_mean&longitude)-1-start, 1
                     var_ssn_area(i_lat, i_lon) = wgt_areaave(var_ssn_mean(i_lat-start:i_lat+start, i_lon-start:i_lon+start), 1.0, 1.0, 0)
                end do
            end do

        printVarSummary(var_ssn_area)
        dims = dimsizes(var_ssn_area(:,:)) 
        ij= ind_resolve(maxind(ndtooned(var_ssn_area(:,:))),dims(0:1))
        lat_location(i) = -ij(0,0)*grid+g_range
        lon_location(i) = ij(0,1)*grid+1.25
        print(g_season(i))
        print(ij(0,0)+" "+ij(0,1))
        ;print(var_ssn_area({-5},{142.5}))
        print("max precip = " + var_ssn_area(ij(0,0),ij(0,1)) + ", lat = " + lat_location(i) + ", lon = " + lon_location(i))

        res@gsnCenterString = g_season(i)+" Clim Precip"
        res@gsnLeftString = g_label(i)
        plot(2*i) = gsn_csm_contour_map_ce(wks,var_ssn_area,res) ; create a default plot
        plot@$unique_string("fxxk ncl")$    = gsn_add_polymarker(wks,plot(2*i),lon_location(i),lat_location(i),polyres)
        ;xyres@gsnCenterString  = g_season(i)+" Center Clim Precip Time Series"
        xyres@tiMainString     = g_season(i)+" Center Clim Precip Time Series"
        plot(2*i+1) = gsn_csm_xy(wks,year,var_ssn(:,{lat_location(i)},{lon_location(i)}),xyres)
    end do

;part5 panel draw
    pres= True
    pres@gsnPanelLabelBar   = True      ;Universial colorbar
    pres@lbLabelFontHeightF = 0.015
    pres@pmLabelBarHeightF  = 0.12
    gsn_panel(wks,plot,(/4,2/),pres)


end
