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

    ; spring
    lon_array=(/10.0, 115.0, 140.0, 155.0, 231.0,  284.0, 310.0/)
    lat_array=(/0.0,  0.0,   -5.0,  5.0,   5.0,    0.0,   0.0/)

    ; summer
    ;lon_array=(/90.0, 140.0, 250.0, 295.0, 345.0,  10.0/)
    ;lat_array=(/11.0, 5.0,   10.0,  5.0,   10.0,  5.0/)
    
    ; winter
    ;lon_array=(/110.0, 140.0,  175.0, 300.0,  47.5/)
    ;lat_array=(/0.0,   -5.0,   -10.0, -7.5,   -17.5/)
    
    ; autumn
    ;lon_array=(/100.0, 140.0,  220.0, 280.0,  330.0, 10.0/)
    ;lat_array=(/0.0,   -5.0,   7.5,   5.0,    7.5,   0.0/)
    
    ; modified_autumn
    ;SON_lon_array=(/100.0, 115.0, 140.0,  220.0, 280.0,  330.0, 10.0/)
    ;SON_lat_array=(/0.0,   0.0,   -5.0,   7.5,   5.0,    7.5,   0.0/)

    ; modified_summer
    ;lon_array=(/90.0, 115.0, 140.0, 250.0, 295.0, 345.0,  10.0/)
    ;lat_array=(/20.0, 0.0,   5.0,   10.0,  5.0,   10.0,  5.0/)
    
    ; modified_winter
    ;lon_array=(/110.0, 115.0, 140.0,  175.0, 300.0,  47.5/)
    ;lat_array=(/0.0,   0.0,   -5.0,   -10.0, -7.5,   -17.5/)

    g_data_path ="/home/ys17-19/cjx/observation_data/gpcp_v02r03_monthly_197901_201901.nc"
    g_font=0.02
    g_latS=-40.
    g_latN=40.
    grid = 2.5
    g_strt_mon = 197901 
    g_lst_mon = 201812
    g_season= "MAM"

	ctrl_file1   = g_data_path
	ctrl_in1     = addfile (ctrl_file1, "r")   ; note the "s" of addfile
	time_hist    = ctrl_in1->time
    yyyymm  = cd_calendar(time_hist,-1)
    istrt   = ind(yyyymm .eq. g_strt_mon)
    ilast   = ind(yyyymm .eq. g_lst_mon)
	var  =ctrl_in1->precip(istrt:ilast,:,:)			; p for unify the var name
    var_ssn = month_to_season(var,g_season)
    var_ssn_mean = dim_avg_n_Wrap(var_ssn,0)
    ;var_ssn_mean = dim_avg_n_Wrap(var,0)
    printVarSummary(var_ssn_mean)
    dims = dimsizes(var_ssn_mean(:,:)) 
    ij= ind_resolve(maxind(ndtooned(var_ssn_mean(:,:))),dims(0:1))
    lat_location = (ij(0,0)-1)*grid-88.75
    lon_location = (ij(0,1)-1)*grid+grid
    print(var_ssn_mean({-2.5},{140}))
    print("max precip = " + var_ssn_mean(ij(0,0),ij(0,1)) + ", lat = " + lat_location + ", lon = " + lon_location)

    wks  = gsn_open_wks("x11","./MAM")      ; send graphics to PNG file
    gsn_define_colormap(wks,"precip2_17lev")
    res                        = True         ; mods desired   
    res@cnFillOn             = True               ; turn on color for contours
    res@cnLinesOn            = False              ; turn off contour lines
    res@cnLineLabelsOn       = False              ; turn off contour line labels
    ;res@cnLevelSelectionMode  = "ManualLevels" ; set manual contour levels
    ;res@cnMinLevelValF        = 4.0         ; set min contour level
    ;res@cnMaxLevelValF        = 12.0          ; set max contour level
    ;res@cnLevelSpacingF       = 1.0          ; set contour interval

    ;  res@cnFillColors =(/2,4,7,8,8,9,11,13/)


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

    res@lbLabelBarOn = True   ; turn off the label bar
    res@lbOrientation          = "vertical"
    res@lbLabelFontHeightF  = g_font              ; make labels smaller
    res@lbLabelStride = 2 

    res@mpFillOn   = False     ; turn off gray continents
    res@mpGeophysicalLineThicknessF = 2
    res@mpGeophysicalLineColor      = "black";"white" 
    ;res@mpFillDrawOrder="PostDraw"
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
    ; res@tmYLLabelFontAspectF = 1.3
    res@tmYLLabelFontThicknessF = 2.0
    ; res@tmYLLabelFontQuality =
    ;-----------------------------------------------------------------------------
     
    res@gsnLeftString = ""
    res@gsnRightString = ""


        
    
    res@gsnLeftString = "Array of Heating Centers ("+g_season+")"

    polyres                   = True
    polyres@gsMarkerIndex     = 2          ; polymarker style
    polyres@gsMarkerSizeF     = 16.          ; polymarker size
    polyres@gsMarkerThicknessF     = 6.          ; polymarker size
    polyres@gsMarkerColor     = "black"          ; polymarker size

    plot = gsn_csm_contour_map_ce(wks,var_ssn_mean,res) ; create a default plot

    ;dimlon=dimsizes(lon_array) 

    ;do ii=0,dimlon-1
    ;    plot@$unique_string("fxxk ncl")$    = gsn_add_polymarker(wks,plot,lon_array(ii),lat_array(ii),polyres)
    ;end do
    draw(plot)
    frame(wks)

    ;lon_array=g_season+"_lon_array"
    ;lat_array=g_season+"_lat_array"
    ;dimlon=dimsizes(lon_array) 
    ;total=0.0
    ;do ii=0,dimlon-1
    ;   total= total+var_ssn_mean({lat | lat_array(ii)},{lon | lon_array(ii)})
    ;end do
    ;print(g_season)
    ;print(total)

    ;var_reference=new((/dimlon/),float)
    ;do ii=0,dimlon-1
    ;   ; plot@$unique_string("fxxk ncl")$    = gsn_add_polymarker(wks,plot,lon_array(ii),lat_array(ii),polyres)
    ;   ;var_reference(ii)=var_reference(ii)+var_ssn({lat | lat_array(ii)},{lon | lon_array(ii)},time|:)*var_ssn_mean({lat | lat_array(ii)},{lon | lon_array(ii)})/total
    ;    print("lon="+lon_array(ii)+" lat="+lat_array(ii) +" proportion="+var_ssn_mean({lat | lat_array(ii)},{lon | lon_array(ii)})/total )
    ;end do

end
