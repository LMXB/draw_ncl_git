begin
  g_font = 0.025
  l_thick= 2
level=(/925,850,500,200/)
do i=0,1,1
  fils = systemfunc("ls /home/ys17-19/cjx/MERRA/MERRA*.hdf.nc") 
  outfile="/home/ys17-19/cjx/figure/MERRA_figure/Antarctic_MERRA_height_"+level(i)+"_cp"
  print(fils)
  setfileoption("nc","SuppressClose",False) ; close too many files
  fin_ctrl = addfiles(fils,"r")
  pre = fin_ctrl[:]->H
  pre_ctrl = pre(:,{level(i)},:,:)
;  pre_ctrl = fin_ctrl->H(120:359:1,{500},:,:)
  pre_ctrl_ssn = month_to_season(pre_ctrl,"MAM")
  printVarSummary(pre_ctrl_ssn)
  idx = (/1,2,4,8,32,36/)
  cp_var=pre_ctrl_ssn(idx,:,:)
  var_cp  = dim_avg_n_Wrap(cp_var,0)
  var  = dim_avg_n_Wrap(pre_ctrl_ssn,0)
  var_diff = var
  var_diff = var_cp-var
  
  wks = gsn_open_wks("png",outfile)     
  gsn_define_colormap(wks,"BlueWhiteOrangeRed")
   
  res                 = True                   
  res@gsnLeftString   = " "                   
  res@gsnRightString  = " "                 
   res@gsnCenterString = " "
;  res@gsnCenterStringFontHeightF = 0.05  
   res@gsnPolar              = "SH"
   res@mpMaxLatF            = -45  

   res@gsnPolarLabelFontHeightF = g_font
   res@mpGeophysicalLineThicknessF = l_thick
   res@mpGridLineThicknessF   = l_thick
 ; res@pmTickMarkDisplayMode = "Always"
  
  ;res@pmTickMarkDisplayMode = "Always"
  res@cnLevelSelectionMode  = "ManualLevels" ; set manual contour levels
;  res@cnLevels      =(/-400, -300,-200,-100, 0, 100 ,400,800, 1200,1600,2000 /)
 ; res@cnFillColors =(/10,26,42,58,74,90,106,122,138,154,170,186,202,218,234,250/)
  res@cnFillColors =(/218, 202, 186, 170, 138, 122, 90, 74, 58, 42, 26 ,10/)
  res@cnMinLevelValF        = -80         ; set min contour level
  res@cnMaxLevelValF        = 120         ; set max contour level
  res@cnLevelSpacingF       = 20          ; set contour interval
  res@cnFillOn      = True                  
  res@cnLinesOn     = False                 
  res@lbLabelFontHeightF = g_font
  res@mpFillOn               = False         
;  res@mpGridSpacingF         = 10.     ;

  
  plot = gsn_csm_contour_map_polar(wks,var_diff,res)
end do
end
