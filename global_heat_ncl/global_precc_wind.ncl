begin

  g_font = 0.025
  l_thick= 2
  ;outfile="/home/ys17-19/cjx/figure/HEAT_MC_figure/global_precc_ttest"
  outfile="/home/ys17-19/cjx/figure/"+case_name+"_figure/"+season+" global_precc_wind_ttest"
  ;HEAT_file="/home/ys17-19/cjx/all_output_data/HEAT_MC_output/HEAT_MC.cam.h0.250-289.nc"
  HEAT_file="/home/ys17-19/cjx/all_output_data/"+case_name+"_output/"+case_name+".cam.h0.250-289.nc"
  ;CTRL_file="/home/ys17-19/cjx/all_output_data/B2000_CTRL_output/B2000_f19g16_CP_CTRL.cam.h0.250-289.nc"
  fin_heat = addfile(HEAT_file,"r")
  fin_ctrl = addfile(CTRL_file,"r")
  pre_heat = fin_heat->PRECC(120:479:1,:,:)
  pre_ctrl = fin_ctrl->PRECC(120:479:1,:,:)
  pre_heat_ssn = month_to_season(pre_heat,season)
  pre_ctrl_ssn = month_to_season(pre_ctrl,season)
  pre_diff_ssn = pre_heat_ssn
  pre_diff_ssn = (pre_heat_ssn - pre_ctrl_ssn)*86400*1000
      var  = dim_avg_n_Wrap(pre_diff_ssn,0)

    plot1 = new(1,"graphic")
    plot2 = new(1,"graphic")
  
  wks = gsn_open_wks("eps",outfile)     
  gsn_define_colormap(wks,"BlueWhiteOrangeRed")
   
  res                 = True  
  res@gsnDraw         = False
  res@gsnFrame        = False
  res@gsnMaximize      = True       ; fill up the page
  res@gsnLeftString   = " "                   
  res@gsnRightString  = " "                 
  res@gsnCenterString = season+" precc + wind850 Diff "
;  res@gsnCenterStringFontHeightF = g_font  
   res@tiMainOn               = False
   res@mpFillOn               = False
   res@mpGeophysicalLineThicknessF = l_thick
   res@mpGridLineThicknessF   = l_thick
;   res@mpLandFillColor        = "blue"
;  res@mpGridSpacingF         = 10.     ;
  ;res@pmTickMarkDisplayMode = "Always"
  res@cnLevelSelectionMode  = "ManualLevels" ; set manual contour levels
;  res@cnLevels      =(/-400, -300,-200,-100, 0, 100 ,400,800, 1200,1600,2000 /)
 ; res@cnFillColors =(/10,26,42,58,74,90,106,122,138,154,170,186,202,218,234,250/)
  ;res@cnFillColors =(/42, 58, 74, 90, 122, 138, 170, 186, 202, 218/)
  res@cnFillColors =(/42, 58, 74, 90, 106, 154, 170, 186, 202, 218/)
  res@cnMinLevelValF        = -0.8         ; set min contour level
  res@cnMaxLevelValF        = 0.8         ; set max contour level
  res@cnLevelSpacingF       = 0.2          ; set contour interval
  res@cnFillOn      = True                  
  res@cnLinesOn     = False                 
  res@lbLabelFontHeightF = g_font
  res@tmYLMajorLengthF=0.01
  res@tmXBMajorLengthF=0.01
  res@tmXBLabelFontHeightF = g_font
  res@tmYLLabelFontHeightF = g_font
  res@tmXBTickSpacingF =60
  res@tmYLTickSpacingF =30
  res@pmLabelBarOrthogonalPosF = 0.15
  res@mpCenterLonF =180
  res@mpMaxLatF=lat_N
  res@mpMinLatF=lat_S
  res@mpMaxLonF=lon_W
  res@mpMinLonF=lon_E

  u_ctrl = fin_ctrl->U(120:479:1,{850},:,:)      
  v_ctrl = fin_ctrl->V(120:479:1,{850},:,:)
  u_heat = fin_heat->U(120:479:1,{850},:,:)   
  v_heat = fin_heat->V(120:479:1,{850},:,:)
 
  v_heat_ssn = month_to_season(v_heat,season)
  u_heat_ssn = month_to_season(u_heat,season)
  v_ctrl_ssn = month_to_season(v_ctrl,season)
  u_ctrl_ssn = month_to_season(u_ctrl,season)
  u_diff_ssn = u_ctrl_ssn
  v_diff_ssn = v_ctrl_ssn
  u_diff_ssn = u_heat_ssn - u_ctrl_ssn
  v_diff_ssn = v_heat_ssn - v_ctrl_ssn
  u_in = dim_avg_n_Wrap(u_diff_ssn,0)
  v_in = dim_avg_n_Wrap(v_diff_ssn,0)

  res_wind                 = True  
  res_wind@gsnDraw         = False
  res_wind@gsnFrame        = False
  res_wind@tmXBTickSpacingF =60
  res_wind@tmYLTickSpacingF =30
  res_wind@lbLabelFontHeightF = g_font
  res_wind@mpCenterLonF = 180.
  res_wind@gsnMaximize      = True       ; fill up the page
  res_wind@gsnLeftString   = " "                   
  res_wind@gsnRightString  = " "                 
  res_wind@gsnCenterString = " " 
  res_wind@tiMainOn               = False
  res_wind@mpFillOn               = False
  res_wind@mpGeophysicalLineThicknessF = l_thick
  res_wind@mpGridLineThicknessF   = l_thick
  res_wind@tmXBLabelFontHeightF = g_font
  res_wind@tmYLLabelFontHeightF = g_font
  res_wind@vcGlyphStyle         = "FillArrow" ;  "CurlyVector" , "WindBarb"   
  res_wind@vcFillArrowEdgeColor     = "black"
  res_wind@vcFillArrowFillColor     = "black"
  res_wind@vcGlyphOpacityF           =0.9
  res_wind@vcFillArrowMinFracWidthF = 0.25 
  res_wind@vcFillArrowHeadMinFracXF = 0.25  
  res_wind@vcFillArrowHeadMinFracYF = 0.25 
  res_wind@vcRefAnnoOn               = True  
  res_wind@vcRefMagnitudeF           = 2      ;标准长度箭头所表示的大小
  res_wind@vcRefLengthF              = 0.045  ;标准长度箭头在图形中的长度
  res_wind@vcRefAnnoBackgroundColor  = "white" ;背景颜色     
  res_wind@vcRefAnnoPerimOn          = False   ;关闭边框   
  res_wind@vcRefAnnoFontHeightF      = 0.014   ;参考箭头标签字体大小      
  res_wind@vcRefAnnoString1On        = False   ;设定参考箭头上、        
  res_wind@vcRefAnnoString2On        = True    ;        下的字符
  res_wind@vcRefAnnoString2          = "2 m/s" 
  res_wind@vcRefAnnoOrthogonalPosF   = -0.3
  res_wind@vcRefAnnoArrowUseVecColor = False
  res_wind@vcRefAnnoArrowEdgeColor   ="black"
  res_wind@vcRefAnnoArrowFillColor   ="black"
  res_wind@vcMinDistanceF            = 0.035

  plot1 = gsn_csm_contour_map(wks,var,res)
  plot2 = gsn_csm_vector(wks,u_in,v_in,res_wind)
 ; plot = gsn_csm_contour_map_polar(wks,pre_diff_sig,res4)
  polyres                   = True
  polyres@gsMarkerIndex     = 10          ; polymarker style
  polyres@gsMarkerSizeF     = 16.          ; polymarker size
  polyres@gsMarkerThicknessF     = 6.          ; polymarker size
  polyres@gsMarkerColor     = "green"          ; polymarker size
  plot1@$unique_string("fxxk ncl")$    = gsn_add_polymarker(wks,plot1,lon_array(j),lat_array(j),polyres)
  overlay(plot1,plot2)
  draw(plot1)
  frame(wks)
  delete(res)
  ;delete(res4)
  ;delete(case_name)
end
