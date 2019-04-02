begin
  g_font = 0.025
  l_thick= 2
  fils = systemfunc("ls /home/yangsong3/data-observation/MERRA/monthly/MERRA*.SUB.nc") 
;  print(fils)
  outfile="/home/ys17-19/cjx/figure/MERRA_figure/Antarctic_MERRA_height"
  setfileoption("nc","SuppressClose",False) ; close too many files
  fin_ctrl = addfiles(fils,"r")
  pre = fin_ctrl[:]->h
  pre_ctrl = pre(0:419:1,{500},:,:)
;  pre_ctrl = fin_ctrl->H(120:359:1,{500},:,:)
  pre_ctrl_ssn = month_to_season(pre_ctrl,"MAM")
      var  = dim_avg_n_Wrap(pre_ctrl_ssn,0)
  
  wks = gsn_open_wks("png",outfile)     
  gsn_define_colormap(wks,"BlueWhiteOrangeRed")
   
  res                 = True                   
  res@gsnLeftString   = " "                   
  res@gsnMaximize      = True       ; fill up the page
;  res@gsnRightString  = "m"                 
   res@gsnCenterString = " "
;  res@gsnCenterStringFontHeightF = 0.05  
   res@gsnPolar              = "SH"
   res@gsnPolarLabelFontHeightF = g_font
   res@mpGeophysicalLineThicknessF = l_thick
   res@mpGridLineThicknessF   = l_thick
  res@lbLabelFontHeightF = g_font
;  res@pmTickMarkDisplayMode = "Always"
;  res@cnLevelSelectionMode  = "ExplicitLevels" ; set manual contour levels
;  res@cnLevelSelectionMode  = "ManualLevels" ; set manual contour levels
;  res@cnLevels      =(/-400, -300,-200,-100, 0, 100 ,400,800, 1200,1600,2000 /)
;  res@cnFillColors =(/218, 202, 186, 170, 154, 122,  90, 74, 58, 42, 26, 10/)
  res@mpMaxLatF              = -45
 ; res@cnFillColors =(/10,26,42,58,74,90,106,122,138,154,170,186,202,218,234,250/)
  res@cnMinLevelValF        = 4900         ; set min contour level
  res@cnMaxLevelValF        = 5800         ; set max contour level
  res@cnLevelSpacingF       = 100          ; set contour interval

 ;   绘制的地图区域
;  res@mpMinLatF    = 10          
;  res@mpMaxLatF    = 80
;  res@mpMinLonF    = 30
;  res@mpMaxLonF    = 130
  
  res@mpFillOn               = False         
;  res@mpGridSpacingF         = 10.     ;

  res@cnFillOn      = False                  
  res@cnLinesOn     = True 
  res@cnLineLabelsOn= True
  
  plot = gsn_csm_contour_map_polar(wks,var,res)
end
