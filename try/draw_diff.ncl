load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
 
;***************************************
 
begin
 
;;;;
;;; read data from grib file
;;;;
 

    outfile="./"
    HEAT_file="/home/ys17-19/cjx/all_output_data/HEAT_MC_output/MAM_HEAT_MC_CP.cam.h0.250-289.nc"
    CTRL_file="/home/ys17-19/cjx/all_output_data/B2000_CTRL_output/B2000_f19g16_CP_CTRL.cam.h0.250-289.nc"
    fin1 = addfile(HEAT_file,"r")
    fin2 = addfile(CTRL_file,"r")
    g_font=0.02
 
;;; get variables: temperature, longitude, latitude
 
    pre_heat = fin1->PRECC(120:479:1,:,:)
    pre_ctrl = fin2->PRECC(120:479:1,:,:)

    pre_diff = pre_heat
    pre_diff = (pre_heat-pre_ctrl) * 86400 * 1000
    pre_diff_ssn = month_to_season(pre_diff,"MAM")
    var  = dim_avg_n_Wrap(pre_diff_ssn,0)
    printVarSummary(var)

;;;;
;;; create plot (png)
;;;;
 
 
    wks = gsn_open_wks("x11",outfile)                 ; open wk station
    gsn_define_colormap(wks,"precip2_17lev")

    res                        = True         ; mods desired  
    res@cnFillOn             = True               ; turn on color for contours
    res@cnLinesOn            = False              ; turn off contour lines
    res@cnLineLabelsOn       = False              ; turn off contour line labels
   ; res@cnLevelSelectionMode  = "ManualLevels" ; set manual contour levels
   ; res@cnMinLevelValF        = 10.0         ; set min contour level
   ; res@cnMaxLevelValF        = 100.0          ; set max contour level
   ; res@cnLevelSpacingF       = 10.0          ; set contour interval

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
    ;res@mpMaxLatF  = g_latN
    ;res@mpMinLatF  = g_latS
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


        
    
    res@gsnLeftString = " "

    ;polyres                   = True
    ;polyres@gsMarkerIndex     = 2          ; polymarker style
    ;polyres@gsMarkerSizeF     = 16.          ; polymarker size
    ;polyres@gsMarkerThicknessF     = 6.          ; polymarker size
    ;polyres@gsMarkerColor     = "black"          ; polymarker size

    plot = gsn_csm_contour_map_ce(wks,var,res) ; create a default plot
    draw(plot)
    frame(wks)
end
