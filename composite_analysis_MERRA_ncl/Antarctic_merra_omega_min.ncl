begin
  g_font = 0.025
  l_thick= 2
level=(/925,850,500,200/)
do i=0,3,1
  fils = systemfunc("ls /home/ys17-19/cjx/MERRA/MERRA*.hdf.nc") 
  outfile="/home/ys17-19/cjx/figure/MERRA_figure/Antarctic_MERRA_OMEGA_"+level(i)+"_max"
  ;print(fils)
  setfileoption("nc","SuppressClose",False) ; close too many files
  fin_ctrl = addfiles(fils,"r")
  pre = fin_ctrl[:]->OMEGA
  pre_ctrl = pre(:,{level(i)},:,:)
;  pre_ctrl = fin_ctrl->H(120:359:1,{500},:,:)
  pre_ctrl_ssn = month_to_season(pre_ctrl,"MAM")
  printVarSummary(pre_ctrl_ssn)
  idx = (/20,21,22,27,28,29,30,31/)
  cp_var=pre_ctrl_ssn(idx,:,:)
  var_cp  = dim_avg_n_Wrap(cp_var,0)
  var  = dim_avg_n_Wrap(pre_ctrl_ssn,0)
  var_diff = var
  var_diff = var_cp-var
  
  wks = gsn_open_wks("png",outfile)     
  gsn_define_colormap(wks,"temp_diff_18lev")
   
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
  ;res@pmTickMarkDisplayMode = "Always"
  res@cnLevelSelectionMode  = "ManualLevels" ; set manual contour levels
  res@cnFillColors =(/2, 4, 6, 8, 10, 11, 11, 13, 15, 17, 19, 20/)
 
  res@cnMinLevelValF        = -0.004         ; set min contour level
  res@cnMaxLevelValF        =  0.004        ; set max contour level
  res@cnLevelSpacingF       = 0.0008          ; set contour interval
  res@cnFillOn      = True                  
  res@cnLinesOn     = False                 
  res@lbLabelFontHeightF = g_font
  res@mpFillOn               = False         
;  res@mpGridSpacingF         = 10.     ;

  
  plot = gsn_csm_contour_map_polar(wks,var_diff,res)
end do
end
