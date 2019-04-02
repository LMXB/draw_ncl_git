begin
;case_name="HEAT_MC"
  level=(/1000,900,500,200/)
  do i=0,0,1
  ;outfile="/home/ys17-19/cjx/figure/heat_test_figure/global_wind_"+level(i)+"_ttest"
  outfile="/home/ys17-19/cjx/figure/"+case_name+"_figure/global_wind_"+level(i)+"_ttest"
  ;HEAT_file="/home/ys17-19/cjx/all_output_data/HEAT_MC_output/HEAT_MC.cam.h0.250-289.nc"
  HEAT_file="/home/ys17-19/cjx/all_output_data/"+case_name+"_output/"+case_name+".cam.h0.250-289.nc"
  CTRL_file="/home/ys17-19/cjx/all_output_data/B2000_CTRL_output/B2000_f19g16_CP_CTRL.cam.h0.250-289.nc"
  fin_heat = addfile(HEAT_file,"r")
  fin_ctrl = addfile(CTRL_file,"r")

  u_ctrl = fin_ctrl->U(120:359:1,{level(i)},:,:)      
  v_ctrl = fin_ctrl->V(120:359:1,{level(i)},:,:)
  u_heat = fin_heat->U(120:359:1,{level(i)},:,:)   
  v_heat = fin_heat->V(120:359:1,{level(i)},:,:)
 
  v_heat_ssn = month_to_season(v_heat,"MAM")
  u_heat_ssn = month_to_season(u_heat,"MAM")
  v_ctrl_ssn = month_to_season(v_ctrl,"MAM")
  u_ctrl_ssn = month_to_season(u_ctrl,"MAM")
  u_diff_ssn = u_ctrl_ssn
  v_diff_ssn = v_ctrl_ssn
  u_diff_ssn = u_heat_ssn - u_ctrl_ssn
  v_diff_ssn = v_heat_ssn - v_ctrl_ssn
  u_in = dim_avg_n_Wrap(u_diff_ssn,0)
  v_in = dim_avg_n_Wrap(v_diff_ssn,0)

  ;ttest
  GW_file="/home/ys17-19/cjx/CTRL_data/B2000_raw_data/B2000_f19g16_CP_CTRL.cam.h0.0252-02.nc"
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
  u_diff_sig=u_in
  v_diff_sig=v_in
  u_diff_sig=mask(u_in, prob1 .lt. siglvl .or. prob2 .lt. siglvl, True)
  v_diff_sig=mask(v_in, prob1 .lt. siglvl .or. prob2 .lt. siglvl, True)
 
  u=u_in
  v=v_in
  u=mask(u_in, prob1 .lt. siglvl .or. prob2 .lt. siglvl, False)
  v=mask(v_in, prob1 .lt. siglvl .or. prob2 .lt. siglvl, False)

  ;printVarSummary(var)
  ;print(prob1)
  ;printVarSummary(pre_diff_sig)

    plot1 = new(1,"graphic")
    plot2 = new(1,"graphic")
   
  wks = gsn_open_wks("x11",outfile)     
  gsn_define_colormap(wks,"GrayWhiteGray")
   
  res                 = True  
  res@gsnDraw         = False
  res@gsnFrame        = False
  res@tmXBTickSpacingF =60
  res@tmYLTickSpacingF =30
  res@lbLabelFontHeightF = g_font
  res@mpCenterLonF = 180.
  ;res@cnLineLabelsOn   = False      ; turn off contour line labels
  res@gsnMaximize      = True       ; fill up the page
  res@gsnLeftString   = " "                   
  res@gsnRightString  = " "                 
  res@gsnCenterString = "Wind"+level(i)+" Diff" 
;  res@gsnCenterStringFontHeightF = g_font  
   res@tiMainOn               = False
   res@mpFillOn               = False
   res@mpGeophysicalLineThicknessF = l_thick
   res@mpGridLineThicknessF   = l_thick
   res@tmXBLabelFontHeightF = g_font
   res@tmYLLabelFontHeightF = g_font
   res@vcGlyphStyle         = "FillArrow" ;  "CurlyVector" , "WindBarb"   
;  res@mpGridSpacingF         = 10.     ;
  ;res@pmTickMarkDisplayMode = "Always"
  ;; 箭头头部大小一致。若要绘制头部大小不一致箭头可参考第4章示例。

  res@vcFillArrowEdgeColor     = "grey"
  res@vcFillArrowFillColor     = "grey"
  res@vcGlyphOpacityF           =0.2
  res@vcFillArrowMinFracWidthF = 0.3 
  res@vcFillArrowHeadMinFracXF = 0.3  
  res@vcFillArrowHeadMinFracYF = 0.3 
  ;; 参考箭头
  res@vcRefAnnoOn               = True  
  res@vcRefMagnitudeF           = 2      ;标准长度箭头所表示的大小
  res@vcRefLengthF              = 0.03  ;标准长度箭头在图形中的长度
  res@vcRefAnnoBackgroundColor  = "white" ;背景颜色     
  res@vcRefAnnoPerimOn          = False   ;关闭边框   
  res@vcRefAnnoFontHeightF      = 0.014   ;参考箭头标签字体大小      
  res@vcRefAnnoString1On        = False   ;设定参考箭头上、        
  res@vcRefAnnoString2On        = True    ;        下的字符
  res@vcRefAnnoString2          = "2 m/s" 
  res@vcRefAnnoOrthogonalPosF   = 0.155
  res@vcRefAnnoArrowUseVecColor = False
  res@vcRefAnnoArrowEdgeColor   ="black"
  res@vcRefAnnoArrowFillColor   ="black"
  res@vcMinDistanceF            = 0.02
  res@mpMaxLatF=lat_N
  res@mpMinLatF=lat_S
  res@mpMaxLonF=lon_W
  res@mpMinLonF=lon_E

  res4                 = True  
  res4@gsnDraw         = False
  res4@gsnFrame        = False
  res4@lbLabelFontHeightF = g_font
  res4@gsnMaximize      = True       ; fill up the page
  res4@gsnLeftString   = " "                   
  res4@gsnRightString  = " "                 
  res4@gsnCenterString = " " 
  res4@tmYLLabelFontHeightF = g_font
  res4@vcGlyphStyle         = "FillArrow" ;  "CurlyVector" , "WindBarb"   
; res4@mpGridSpacingF         = 10.     ;
  ;re4s@pmTickMarkDisplayMode = "Always"
  ;; 4箭头头部大小一致。若要绘制头部大小不一致箭头可参考第4章示例。
  res4@vcFillArrowEdgeColor     = "black"
  res4@vcFillArrowFillColor     = "black"
  res4@vcFillArrowMinFracWidthF = 0.5 
  res4@vcFillArrowHeadMinFracXF = 0.5  
  res4@vcFillArrowHeadMinFracYF = 0.5 
  ;; 4参考箭头
  res4@vcRefAnnoOn               = True  
  res4@vcRefMagnitudeF           = 2      ;标准长度箭头所表示的大小
  res4@vcRefLengthF              = 0.03  ;标准长度箭头在图形中的长度
  res4@vcRefAnnoBackgroundColor  = "white" ;背景颜色     
  res4@vcRefAnnoPerimOn          = False   ;关闭边框   
  res4@vcRefAnnoFontHeightF      = 0.014   ;参考箭头标签字体大小      
  res4@vcRefAnnoString1On        = False   ;设定参考箭头上、        
  res4@vcRefAnnoString2On        = True    ;        下的字符
  res4@vcRefAnnoString2          = "2 m/s" 
  res4@vcRefAnnoOrthogonalPosF   = 0.155
  res4@vcMinDistanceF            = 0.02
  res4@vcRefAnnoArrowEdgeColor   ="black"
  res4@vcRefAnnoArrowFillColor   ="black"

  plot1 = gsn_csm_vector_map(wks,u,v,res)
  plot2 = gsn_csm_vector(wks,u_diff_sig,v_diff_sig,res4)
  ;plot  = gsn_csm_vector_map_polar(wks,u,v,res)
  polyres                   = True
  polyres@gsMarkerIndex     = 10          ; polymarker style
  polyres@gsMarkerSizeF     = 16.          ; polymarker size
  polyres@gsMarkerThicknessF     = 6.          ; polymarker size
  polyres@gsMarkerColor     = "green"          ; polymarker size
  plot1@$unique_string("fxxk ncl")$    = gsn_add_polymarker(wks,plot1,lon_array(j),lat_array(j),polyres)
  overlay(plot1,plot2)
  draw(plot1)
  frame(wks)
  end do
delete(res)
delete(res4)
delete(level)
;delete(case_name)
end
