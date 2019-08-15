begin
  level = (/200, 500, 850/)
  g_font = 0.025
  l_thick= 2
  fin_psidev = addfile("/home/ys17-19/cjx/all_output_data/HEAT_EMC_output/wave_activity_flux/psidev.monthly.1990.nc","r")
  fin_Fx = addfile("/home/ys17-19/cjx/all_output_data/HEAT_EMC_output/wave_activity_flux/TN2001-Fx.monthly.1990.nc","r")
  fin_Fy = addfile("/home/ys17-19/cjx/all_output_data/HEAT_EMC_output/wave_activity_flux/TN2001-Fy.monthly.1990.nc","r")
  do j = 0, 2, 1
  outfile = "/home/ys17-19/cjx/figure/HEAT_EMC_figure/wave_activity_flux " + level(j)
  pre_psidev = fin_psidev->psidev(:,{level(j)},:,:)
      psidev  = dim_avg_n_Wrap(pre_psidev,0)
  pre_Fy = fin_Fy->Fy(:,{level(j)},:,:)
      Fy  = dim_avg_n_Wrap(pre_Fy,0)
  pre_Fx = fin_Fx->Fx(:,{level(j)},:,:)
      Fx  = dim_avg_n_Wrap(pre_Fx,0)
      ;print(sqrt(Fx*Fx+Fy*Fy))
        
    plot1 = new(1,"graphic")
    plot2 = new(1,"graphic")
  
  wks = gsn_open_wks("png", outfile)     
  gsn_define_colormap(wks,"BlueWhiteOrangeRed")
   
  res                 = True  
  res@gsnDraw         = False
  res@gsnFrame        = False
  res@gsnMaximize      = True       ; fill up the page
  res@gsnLeftString   = " "                   
  res@gsnRightString  = " "                 
  res@gsnCenterString = level(j) + " hPa streamfunction(color) + wave-activity flux(arrow)"
;  res@gsnCenterStringFontHeightF = g_font  
   res@tiMainOn               = False
   res@mpFillOn               = False
   res@mpGeophysicalLineThicknessF = l_thick
;   res@mpLandFillColor        = "blue"
;  res@mpGridSpacingF         = 10.     ;
  ;res@pmTickMarkDisplayMode = "Always"
  res@cnLevelSelectionMode  = "ManualLevels" ; set manual contour levels
; ; res@cnLevels      =(/-400, -300,-200,-100, 0, 100 ,400,800, 1200,1600,2000 /)
 ;; res@cnFillColors =(/10,26,42,58,74,90,106,122,138,154,170,186,202,218,234,250/)
  ;;res@cnFillColors =(/42, 58, 74, 90, 122, 138, 170, 186, 202, 218/)
  res@cnFillColors =(/42, 58, 74, 90, 106, 154, 170, 186, 202, 218/)
  res@cnMinLevelValF        = -0.4e7         ; set min contour level
  res@cnMaxLevelValF        =  0.4e7         ; set max contour level
  res@cnLevelSpacingF       =  0.1e7          ; set contour interval
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

  res_wind                 = True  
  res_wind@gsnDraw         = False
  res_wind@gsnFrame        = False
  res_wind@tmXBTickSpacingF =60
  res_wind@tmYLTickSpacingF =30
  res_wind@lbLabelFontHeightF = g_font
  res_wind@gsnMaximize      = True       ; fill up the page
  res_wind@gsnLeftString   = " "                   
  res_wind@gsnRightString  = " "                 
  res_wind@gsnCenterString = " " 
  res_wind@tiMainOn               = False
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
  res_wind@vcRefMagnitudeF           = 0.5      ;标准长度箭头所表示的大小
  res_wind@vcRefLengthF              = 0.025  ;标准长度箭头在图形中的长度
  res_wind@vcRefAnnoBackgroundColor  = "white" ;背景颜色     
  res_wind@vcRefAnnoPerimOn          = False   ;关闭边框   
  res_wind@vcRefAnnoFontHeightF      = 0.014   ;参考箭头标签字体大小      
  res_wind@vcRefAnnoString1On        = False   ;设定参考箭头上、        
  res_wind@vcRefAnnoString2On        = True    ;        下的字符
  res_wind@vcRefAnnoString2          = "0.5 m/s" 
  res_wind@vcRefAnnoOrthogonalPosF   = -0.3
  res_wind@vcRefAnnoArrowUseVecColor = False
  res_wind@vcRefAnnoArrowEdgeColor   ="black"
  res_wind@vcRefAnnoArrowFillColor   ="black"
  res_wind@vcMinDistanceF            = 0.035
  res_wind@vcMaxMagnitudeF            = 1
  res_wind@vcMinMagnitudeF            = 0.1

  plot1 = gsn_csm_contour_map(wks,psidev,res)
  plot2 = gsn_csm_vector(wks,Fx,Fy,res_wind)
 ; plot = gsn_csm_contour_map_polar(wks,pre_diff_sig,res4)
  polyres                   = True
  polyres@gsMarkerIndex     = 10          ; polymarker style
  polyres@gsMarkerSizeF     = 16.          ; polymarker size
  polyres@gsMarkerThicknessF     = 6.          ; polymarker size
  polyres@gsMarkerColor     = "green"          ; polymarker size
  plot1@$unique_string("fxxk ncl")$    = gsn_add_polymarker(wks,plot1,115,0,polyres)
  overlay(plot1,plot2)
  draw(plot1)
  frame(wks)
  delete(res)
  delete(res_wind)
  ;delete(case_name)
  end do
end
