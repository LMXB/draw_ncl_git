begin
  g_font = 0.025    
  l_thick= 2

  outfile="/home/ys17-19/cjx/figure/heat_test_figure/global_streamfunction_200"
  ;outfile="/home/ys17-19/cjx/figure/"+case_name+"_figure/global_streamfunction_200_diff"
  f_ctrl_U = addfile("/home/ys17-19/data-model/CESM_CTRL/F2000_F19_CAM4_CTRL/pro/CTRL.cam.h0.U.1-110.nc","r")
  f_ctrl_V = addfile("/home/ys17-19/cjx/all_output_data/CTRL_output_data/CTRL.cam.h0.1-65.V.nc","r")
  f_heat = addfile("/home/ys17-19/cjx/all_output_data/HEAT_TEST_output_data/MAM_HEAT.cam.h0.1-30.nc","r")
 ; f_heat = addfile=("/home/ys17-19/cjx/all_output_data/"+case_name+"_output_data/MAM_HEAT.cam.h0.1-30.nc","r")

  u_ctrl = f_ctrl_U->U(120:359:1,{200},:,:)      
  v_ctrl = f_ctrl_V->V(120:359:1,{200},:,:)
  u_heat = f_heat->U(120:359:1,{200},:,:)   
  v_heat = f_heat->V(120:359:1,{200},:,:)
 
  v_heat_ssn = month_to_season(v_heat,"MAM")
  u_heat_ssn = month_to_season(u_heat,"MAM")
  v_ctrl_ssn = month_to_season(v_ctrl,"MAM")
  u_ctrl_ssn = month_to_season(u_ctrl,"MAM")
  u = dim_avg_n_Wrap(u_heat_ssn,0)
  v = dim_avg_n_Wrap(v_heat_ssn,0)
  u_ = dim_avg_n_Wrap(u_ctrl_ssn,0)
  v_ = dim_avg_n_Wrap(v_ctrl_ssn,0)
  sf = u
  sf_= u
  sf_diff =u
  sfvp = uv2sfvpG(u,v)
  sf   = (/sfvp(0,:,:)/)
  sfvp_ = uv2sfvpG(u_,v_)
  sf_   = (/sfvp_(0,:,:)/)
  sf_diff=sf-sf_
 ; printVarSummary(sf)
 ; printVarSummary(sf_diff)

   
  wks = gsn_open_wks("png",outfile)     
  gsn_define_colormap(wks,"BlueWhiteOrangeRed")
   
  res1                 = True  
  res1@gsnDraw         = False
  res1@lbLabelFontHeightF = g_font
   res1@tiMainOn               = False
;   res1@mpLandFillColor        = "blue"
;  res1@mpGridSpacingF         = 10.     ;
  ;res1@pmTickMarkDisplayMode = "Always"
  ;res1@lbLabelFontHeightF = g_font
 ; res1@tmXBMode ="Manual"
  res1@pmLabelBarOrthogonalPosF =0.3
  res1@tmXBTickSpacingF     = 60
  res1@tmXBLabelFontHeightF  = g_font
  res1@tmYLLabelFontHeightF  = g_font
  res1@gsnFrame        = False
 ; res1@cnLevelSelectionMode  = "ManualLevels" ; set manual contour levels
 ; res1@cnLevels      =(/-400, -300,-200,-100, 0, 100 ,400,800, 1200,1600,2000 /)
 ; res1@cnFillColors =(/10,26,42,58,74,90,106,122,138,154,170,186,202,218,234,250/)
 ; res1@cnFillColors =(/218, 202, 186, 170, 138, 122, 90, 74, 58, 42, 26 ,10/)
 ; res1@cnMinLevelValF        = -80         ; set min contour level
 ; res1@cnMaxLevelValF        = 120         ; set max contour level
 ; res1@cnLevelSpacingF       = 20          ; set contour interval
  res1@cnLinesOn     = False                 
  res1@cnFillOn      = True
  res1@cnInfoLabelOn = False
 ;   绘制的地图区域
  res1@mpMinLatF    = -90          
  res1@mpMaxLatF    = 10
;  res1@mpMinLonF    = 30
;  res1@mpMaxLonF    = 130
   res1@mpFillOn               = False
   res1@gsnContourZeroLineThicknessF = 0
  plot = gsn_csm_contour_map(wks,sf_diff,res1)
  plot = ColorNegDashZeroPosContour(plot, "black" ,"black", "red")
  draw(plot)
  frame(wks)


end
