begin
  outfile="/home/ys17-19/cjx/figure/MERRA_figure/global_MERRA_height"
  fils = systemfunc("ls /home/ys17-19/cjx/MERRA/MERRA*.nc") 
  setfileoption("nc","SuppressClose",False) ; close too many files
  fin_ctrl = addfiles(fils,"r")
  pre_ = fin_ctrl[:]->H
  pre_ctrl = pre_(:,{500},:,:)
  pre_ctrl_ssn = month_to_season(pre_ctrl,"MAM")
      var  = dim_avg_n_Wrap(pre_ctrl_ssn,0)
  
  wks = gsn_open_wks("png",outfile)     
  gsn_define_colormap(wks,"BlueWhiteOrangeRed")
   
  res                 = True                   
  res@gsnLeftString   = "height"                   
;  res@gsnRightString  = "m"                 
   res@gsnCenterString = "500 hPa"
;  res@gsnCenterStringFontHeightF = 0.05  
  
  res@pmTickMarkDisplayMode = "Always"
  res@cnLevelSelectionMode  = "ExplicitLevels" ; set manual contour levels
;  res@cnLevels      =(/-400, -300,-200,-100, 0, 100 ,400,800, 1200,1600,2000 /)
;  res@cnFillColors =(/218, 202, 186, 170, 154, 122,  90, 74, 58, 42, 26, 10/)

 ; res@cnFillColors =(/10,26,42,58,74,90,106,122,138,154,170,186,202,218,234,250/)
 ; res@cnMinLevelValF        = -2800         ; set min contour level
 ; res@cnMaxLevelValF        = 2800         ; set max contour level
 ; res@cnLevelSpacingF       = 400          ; set contour interval
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
  plot = gsn_csm_contour_map(wks,var,res)
end
