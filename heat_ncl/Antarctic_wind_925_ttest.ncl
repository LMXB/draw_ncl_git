begin
  g_font = 0.025    
  l_thick= 2

  ;outfile="/home/ys17-19/cjx/figure/heat_test_figure/Antarctic_wind_925_ttest"
  outfile="/home/ys17-19/cjx/figure/"+case_name+"_figure/Antarctic_wind_925_ttest"
  f_ctrl_U = addfile("/home/ys17-19/data-model/CESM_CTRL/F2000_F19_CAM4_CTRL/pro/CTRL.cam.h0.U.1-110.nc","r")
  f_ctrl_V = addfile("/home/ys17-19/cjx/all_output_data/CTRL_output_data/CTRL.cam.h0.1-65.V.nc","r")
  ;f_heat = addfile("/home/ys17-19/cjx/all_output_data/HEAT_TEST_output_data/MAM_HEAT.cam.h0.1-30.nc","r")
  f_heat =addfile("/home/ys17-19/cjx/all_output_data/"+case_name+"_output_data/MAM_HEAT.cam.h0.1-30.nc","r")

  u_ctrl = f_ctrl_U->U(120:359:1,{925},:,:)      
  v_ctrl = f_ctrl_V->V(120:359:1,{925},:,:)
  u_heat = f_heat->U(120:359:1,{925},:,:)   
  v_heat = f_heat->V(120:359:1,{925},:,:)
 
  v_heat_ssn = month_to_season(v_heat,"MAM")
  u_heat_ssn = month_to_season(u_heat,"MAM")
  v_ctrl_ssn = month_to_season(v_ctrl,"MAM")
  u_ctrl_ssn = month_to_season(u_ctrl,"MAM")
  u_diff_ssn = u_ctrl_ssn
  v_diff_ssn = v_ctrl_ssn
  u_diff_ssn = u_heat_ssn - u_ctrl_ssn
  v_diff_ssn = v_heat_ssn - v_ctrl_ssn
  u = dim_avg_n_Wrap(u_diff_ssn,0)
  v = dim_avg_n_Wrap(v_diff_ssn,0)

  ;ttest
  GW_file="/home/ys17-19/cjx/model-data/MAM_HEAT_TEST/MAM_HEAT_TEST.cam.h0.0015-12.nc"
  GW_IN=addfile(GW_file,"r")
  gw=GW_IN->gw
  siglvl = 0.05
  x1tmp = u_heat_ssn(lat |:,lon |:,time |:)
  y1tmp = u_ctrl_ssn(lat |:,lon |:,time |:)
  aveX1 = dim_avg(x1tmp)
  aveY1 = dim_avg(y1tmp)
  varX1 = dim_variance(x1tmp)
  varY1 = dim_variance(y1tmp)
  eqvX1 = equiv_sample_size(x1tmp,siglvl,0)
  eqvY1 = equiv_sample_size(y1tmp,siglvl,0)
  nX1   = wgt_areaave(eqvX1, gw, 1, 0)
  nY1   = wgt_areaave(eqvY1, gw, 1, 0)
  prob1 = ttest(aveX1, varX1, nX1, aveY1, varY1, nY1, False, False)

  x2tmp = v_heat_ssn(lat |:,lon |:,time |:)
  y2tmp = v_ctrl_ssn(lat |:,lon |:,time |:)
  aveX2 = dim_avg(x2tmp)
  aveY2 = dim_avg(y2tmp)
  varX2 = dim_variance(x2tmp)
  varY2 = dim_variance(y2tmp)
  eqvX2 = equiv_sample_size(x2tmp,siglvl,0)
  eqvY2 = equiv_sample_size(y2tmp,siglvl,0)
  nX2   = wgt_areaave(eqvX2, gw, 1, 0)
  nY2   = wgt_areaave(eqvY2, gw, 1, 0)
  prob2 = ttest(aveX2, varX2, nX2, aveY2, varY2, nY2, False, False)
  u_diff_sig=u
  v_diff_sig=v
  u_diff_sig=mask(u, prob1 .lt. siglvl .and. prob2 .lt. siglvl, True)
  v_diff_sig=mask(v, prob1 .lt. siglvl .and. prob2 .lt. siglvl, True)
  ;printVarSummary(var)
  ;printVarSummary(prob)
  ;printVarSummary(pre_diff_sig)

    plot1 = new(1,"graphic")
    plot2 = new(1,"graphic")
   
  wks = gsn_open_wks("png",outfile)     
  gsn_define_colormap(wks,"GrayWhiteGray")
   
  res                 = True  
  res@gsnDraw         = False
  res@gsnFrame        = False
  res@lbLabelFontHeightF = g_font
  ;res@cnLineLabelsOn   = False      ; turn off contour line labels
  res@gsnMaximize      = True       ; fill up the page
  res@gsnLeftString   = " "                   
  res@gsnRightString  = " "                 
  res@gsnCenterString = " "
;  res@gsnCenterStringFontHeightF = g_font  
   res@gsnPolar               = "SH"
   res@gsnPolarLabelFontHeightF = g_font
   res@tiMainOn               = False
   res@mpMaxLatF              = -45  
   res@mpFillOn               = False
   res@mpGeophysicalLineThicknessF = l_thick
   res@mpGridLineThicknessF   = l_thick
   res@vcGlyphStyle         = "FillArrow" ;  "CurlyVector" , "WindBarb"   
;  res@mpGridSpacingF         = 10.     ;
  ;res@pmTickMarkDisplayMode = "Always"
  ;; 箭头头部大小一致。若要绘制头部大小不一致箭头可参考第4章示例。
  res@vcFillArrowMinFracWidthF = 0.5 
  res@vcFillArrowHeadMinFracXF = 0.5  
  res@vcFillArrowHeadMinFracYF = 0.5 
  ;; 参考箭头
  res@vcRefAnnoOn               = True  
  res@vcRefMagnitudeF           = 0.5      ;标准长度箭头所表示的大小
  res@vcRefLengthF              = 0.01  ;标准长度箭头在图形中的长度
  res@vcRefAnnoBackgroundColor  = "white" ;背景颜色     
  res@vcRefAnnoPerimOn          = False   ;关闭边框   
  res@vcRefAnnoFontHeightF      = 0.015   ;参考箭头标签字体大小      
  res@vcRefAnnoString1On        = False   ;设定参考箭头上、        
  res@vcRefAnnoString2On        = True    ;        下的字符
  res@vcRefAnnoString2          = "0.5 m/s"  
  res@vcMinDistanceF            = 0.02

  res4                  = True       ; use plot options
  res4@cnFillOn         = True       ; Fill contours
  res4@cnLinesOn        = False;True      ; turn off contour lines
  res4@gsnFrame         = False
  res4@gsnDraw  = False
  res4@gsnLeftString   = " "                   
  res4@gsnRightString  = " "                 
  res4@gsnCenterString = " "
  res4@cnLineThicknessF = 2
  res4@cnLineColor      = "black"
  res4@cnInfoLabelOn = False
;  res4@cnMonoFillPattern    = True
;  res4@cnFillPattern = 17
;  res4@cnMonoFillScale = True
;  res4@cnFillScaleF = 1.
;  res4@cnMonoFillColor = True
;  res4@cnFillDotSizeF = 0.004
  res4@cnFillOn     = True
  res4@cnLevels     = (/0,1/)
  res4@cnFillColor  = (/29,29,29/)
  res4@cnFillOpacityF=0.5
  

  plot1 = gsn_csm_vector_map_polar(wks,u,v,res)
  plot2 = gsn_csm_contour(wks,u_diff_sig,res4)
;  plot  = gsn_csm_vector_map_polar(wks,u,v,res)
  overlay(plot1,plot2)
  draw(plot1)
  frame(wks)
  delete(res)
  delete(res4)

end
