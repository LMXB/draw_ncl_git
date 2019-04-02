begin
  g_font = 0.025
  l_thick= 2
level=(/925,850,500,200/)
do i=0,3,1
  fils = systemfunc("ls /home/ys17-19/cjx/MERRA/MERRA*.hdf.nc") 
  outfile="/home/ys17-19/cjx/figure/MERRA_figure/Antarctic_MERRA_wind_"+level(i)+"_cp"
  print(fils)
  setfileoption("nc","SuppressClose",False) ; close too many files
  fin_ctrl = addfiles(fils,"r")
  pre = fin_ctrl[:]->H
  u_ = fin_ctrl[:]->U     
  v_ = fin_ctrl[:]->V
  u_ctrl = u_(:,{level(i)},:,:)
  v_ctrl = v_(:,{level(i)},:,:)
  v_ctrl_ssn = month_to_season(v_ctrl,"MAM")
  u_ctrl_ssn = month_to_season(u_ctrl,"MAM")
  u_var  = dim_avg_n_Wrap(u_ctrl_ssn,0)
  v_var  = dim_avg_n_Wrap(v_ctrl_ssn,0)
  idx = (/1,2,4,8,32,36/)
  u_cp_var=u_ctrl_ssn(idx,:,:)
  v_cp_var=v_ctrl_ssn(idx,:,:)
  u_var_cp  = dim_avg_n_Wrap(u_cp_var,0)
  v_var_cp  = dim_avg_n_Wrap(v_cp_var,0)
  u_var_diff = u_var_cp
  v_var_diff = v_var_cp
  u_var_diff = u_var_cp-u_var
  v_var_diff = v_var_cp-v_var

  
  wks = gsn_open_wks("png",outfile)     
  gsn_define_colormap(wks,"BlueWhiteOrangeRed")
   
  res                 = True                   
  res@gsnLeftString   = " "                   
  res@gsnRightString  = " "                 
   res@gsnCenterString = " "
;  res@gsnCenterStringFontHeightF = 0.05  
   res@gsnPolar              = "SH"
   res@mpMaxLatF            = -45  

  ;; 参考箭头
  res@vcRefAnnoOn               = True  
  res@vcRefMagnitudeF           = 10      ;标准长度箭头所表示的大小
  res@vcRefLengthF              = 0.1  ;标准长度箭头在图形中的长度
  res@vcRefAnnoBackgroundColor  = "white" ;背景颜色     
  res@vcRefAnnoPerimOn          = False   ;关闭边框   
  res@vcRefAnnoFontHeightF      = 0.015   ;参考箭头标签字体大小      
  res@vcRefAnnoString1On        = False   ;设定参考箭头上、        
  res@vcRefAnnoString2On        = True    ;        下的字符
  res@vcRefAnnoString2          = "10 m/s"  
  res@vcMinDistanceF            = 0.02

   res@gsnPolarLabelFontHeightF = g_font
   res@mpGeophysicalLineThicknessF = l_thick
   res@mpGridLineThicknessF   = l_thick
 ; res@pmTickMarkDisplayMode = "Always"
  
  ;res@pmTickMarkDisplayMode = "Always"
  res@cnLevelSelectionMode  = "ManualLevels" ; set manual contour levels
;  res@cnLevels      =(/-400, -300,-200,-100, 0, 100 ,400,800, 1200,1600,2000 /)
 ; res@cnFillColors =(/10,26,42,58,74,90,106,122,138,154,170,186,202,218,234,250/)
  res@lbLabelFontHeightF = g_font

  plot = gsn_csm_vector_map_polar(wks,u_var_diff,v_var_diff,res)
end do
end
