    load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
    load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
 
;***************************************
 
begin
 
;;;;
;;; read data from grib file
;;;;
 

    outfile="/home/ys17-19/cjx/figure/ctrl_figure/global_ctrl_precc"
    CTRL_file="/home/ys17-19/cjx/observation_data/gpcp_v02r03_monthly_197901_201901.nc"
    fin_ctrl = addfile(CTRL_file,"r")
    g_font=0.02
 
;;; get variables: temperature, longitude, latitude
 
    pre_ctrl = fin_ctrl->precip(0:479:1,:,:) 
    pre_ctrl_ssn = month_to_season(pre_ctrl,"MAM")
    PREC = dim_avg_n_Wrap(pre_ctrl_ssn,0)
    printVarSummary(PREC)

;;;;
;;; create plot (png)
;;;;
 
 
    wks = gsn_open_wks("x11",outfile)                 ; open wk station
    gsn_define_colormap(wks,"precip_diff_12lev")

    res                        = True         ; mods desired  
    res@cnFillOn             = True               ; turn on color for contours
    res@cnLinesOn            = False              ; turn off contour lines
    res@cnLineLabelsOn       = False              ; turn off contour line labels
    res@cnLevelSelectionMode  = "ManualLevels" ; set manual contour levels
    res@cnMinLevelValF        = 1.0         ; set min contour level
    res@cnMaxLevelValF        = 10          ; set max contour level
    res@cnLevelSpacingF       = 1.          ; set contour interval
   ;  res@cnLevels      =(/-1.5,-1,-0.5,0,0.5,1,1.5/)
     res@cnFillColors =(/2,4,5,6,7,9,10,11,13/)


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


        
    
    res@gsnLeftString = "precipitation"

    ;polyres                   = True
    ;polyres@gsMarkerIndex     = 2          ; polymarker style
    ;polyres@gsMarkerSizeF     = 16.          ; polymarker size
    ;polyres@gsMarkerThicknessF     = 6.          ; polymarker size
    ;polyres@gsMarkerColor     = "black"          ; polymarker size

    plot = gsn_csm_contour_map_ce(wks,PREC,res) ; create a default plot
    draw(plot)
    frame(wks)
end
