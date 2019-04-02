begin
  g_font = 0.025
  l_thick= 2
  outfile="/home/ys17-19/cjx/figure/test"
  CTRL_file="/home/ys17-19/data-model/CESM_CTRL/F2000_F19_CAM4_CTRL/pro/CTRL.cam.h0.Z3.1-110.nc"
  fin_ctrl = addfile(CTRL_file,"r")
  pre_ctrl = fin_ctrl->Z3(120:359:1,{500},:,:)
  printVarSummary(pre_ctrl)
  pre_ctrl_ssn = month_to_season(pre_ctrl,"MAM")
      var  = dim_avg_n_Wrap(pre_ctrl_ssn,0)
  
  wks = gsn_open_wks("x11",outfile) 
  plot = new(2,graphic)
  gsn_define_colormap(wks,"BlueWhiteOrangeRed")
   
  res                 = True                   
  res@gsnLeftString   = " "                   
  res@gsnRightString  = " "                 
   res@gsnCenterString = " "
   res@gsnDraw  = False                          ; don't draw
   res@gsnFrame = False 
   res@gsnPolar              = "NH"
   res@mpMaxLatF            = 35  
   res@lbLabelFontHeightF = g_font
   res@gsnPolarLabelFontHeightF = g_font
   res@mpGeophysicalLineThicknessF = l_thick
   res@mpGridLineThicknessF   = l_thick

;  res@pmTickMarkDisplayMode = "Always"
  res@cnLevelSelectionMode  = "ManualLevels" ; set manual contour levels
;  res@cnLevels      =(/-400, -300,-200,-100, 0, 100 ,400,800, 1200,1600,2000 /)
;  res@cnFillColors =(/218, 202, 186, 170, 154, 122,  90, 74, 58, 42, 26, 10/)

 ; res@cnFillColors =(/10,26,42,58,74,90,106,122,138,154,170,186,202,218,234,250/)
  res@cnMinLevelValF        = 5000         ; set min contour level
  res@cnMaxLevelValF        = 5800         ; set max contour level
  res@cnLevelSpacingF       = 100          ; set contour interval
  res@mpFillOn               = False         
  res@cnFillOn      = True                  
  res@cnLinesOn     = False 
  res@cnLineLabelsOn= True
  

  plot(0) = gsn_csm_contour_map_polar(wks,var,res)
  plot(1) = gsn_csm_contour_map_polar(wks,var,res)
  gsn_panel(wks,plot,(/2,1/),False)
end
