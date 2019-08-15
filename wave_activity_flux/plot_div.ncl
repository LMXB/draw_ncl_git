begin
  level = (/200, 500, 850/)
  g_font = 0.025
  l_thick= 2
  fin_Fx = addfile("/home/ys17-19/cjx/all_output_data/HEAT_EMC_output/wave_activity_flux/TN2001-Fx.monthly.1990.nc","r")
  fin_Fy = addfile("/home/ys17-19/cjx/all_output_data/HEAT_EMC_output/wave_activity_flux/TN2001-Fy.monthly.1990.nc","r")
  do j = 0, 2, 1
  outfile = "/home/ys17-19/cjx/figure/HEAT_EMC_figure/div_wave_activity_flux " + level(j)
  pre_Fy = fin_Fy->Fy(:,{level(j)},:,:)
      Fy  = dim_avg_n_Wrap(pre_Fy,0)
  pre_Fx = fin_Fx->Fx(:,{level(j)},:,:)
      Fx  = dim_avg_n_Wrap(pre_Fx,0)
  dv=Fx
  dv=uv2dv_cfd(Fx,Fy,Fx&lat,Fx&lon,0)
  printVarSummary(dv)
      ;print(sqrt(Fx*Fx+Fy*Fy))
        
  wks = gsn_open_wks("png", outfile)     
  gsn_define_colormap(wks,"BlueWhiteOrangeRed")
   
  res                 = True  
  res@gsnDraw         = False
  res@gsnFrame        = False
  res@gsnLeftString   = " "                   
  res@gsnRightString  = " "                 
  res@gsnCenterString = level(j) + " div_wave-activity flux "
;  res@gsnCenterStringFontHeightF = g_font  
   res@mpGeophysicalLineThicknessF = l_thick
   res@mpFillOn       = False
;   res@mpLandFillColor        = "blue"
;  res@mpGridSpacingF         = 10.     ;
  ;res@pmTickMarkDisplayMode = "Always"
  res@cnLevelSelectionMode  = "ManualLevels" ; set manual contour levels
  res@cnFillColors =(/42, 58, 74, 90, 106, 154, 170, 186, 202, 218/)
  res@cnMinLevelValF        = -2e-6        ; set min contour level
  res@cnMaxLevelValF        =  2e-6         ; set max contour level
  res@cnLevelSpacingF       = 0.5e-6          ; set contour interval
  res@cnFillOn      = True                  
  res@cnLinesOn     = False                 
  res@lbLabelFontHeightF = g_font
  res@tmYLMajorLengthF=0.01
  res@tmXBMajorLengthF=0.01
  res@tmXBLabelFontHeightF = g_font
  res@tmYLLabelFontHeightF = g_font
  res@tmXBTickSpacingF =60
  res@tmYLTickSpacingF =30
  res@mpCenterLonF =180
  res@lbLabelBarOn = True
  res@lbOrientation    = "Vertical"
  res@pmLabelBarOrthogonalPosF = 0.05
  ;res@pmLabelBarParallelPosF  =0.02
  res@gsnMaximize      = True       ; fill up the page

  plot1 = gsn_csm_contour_map(wks,dv,res)
 ; plot = gsn_csm_contour_map_polar(wks,pre_diff_sig,res4)
  polyres                   = True
  polyres@gsMarkerIndex     = 10          ; polymarker style
  polyres@gsMarkerSizeF     = 16.          ; polymarker size
  polyres@gsMarkerThicknessF     = 6.          ; polymarker size
  polyres@gsMarkerColor     = "green"          ; polymarker size
  plot1@$unique_string("fxxk ncl")$    = gsn_add_polymarker(wks,plot1,115,0,polyres)
  draw(plot1)
  frame(wks)
  delete(res)
  ;delete(case_name)
  end do
end
