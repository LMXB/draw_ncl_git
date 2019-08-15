begin
  level=(/1000,900,500,200/)
  ;case_name="HEAT_F"
  g_font = 0.025
  l_thick= 2
  do i=2,2,1
  ;outfile="/home/ys17-19/cjx/figure/HEAT_MC_figure/polar_height_"+level(i)+"_ttest"
  outfile="/home/ys17-19/cjx/figure/"+case_name+"_figure/polar_height_"+level(i)+"_ttest"
  ;HEAT_file="/home/ys17-19/cjx/all_output_data/HEAT_MC_output/HEAT_MC.cam.h0.250-289.nc"
  HEAT_file="/home/ys17-19/cjx/all_output_data/"+case_name+"_output/"+case_name+".cam.h0.250-289.nc"
  ;CTRL_file="/home/ys17-19/cjx/all_output_data/B2000_CTRL_output/B2000_f19g16_CP_CTRL.cam.h0.250-289.nc"
  fin_heat = addfile(HEAT_file,"r")
  fin_ctrl = addfile(CTRL_file,"r")
  pre_heat = fin_heat->Z3(120:479:1,{level(i)},:,:)
  pre_ctrl = fin_ctrl->Z3(120:479:1,{level(i)},:,:)
  pre_heat_ssn = month_to_season(pre_heat,"MAM")
  pre_ctrl_ssn = month_to_season(pre_ctrl,"MAM")
  pre_diff_ssn = pre_heat_ssn
  pre_diff_ssn = (pre_heat_ssn - pre_ctrl_ssn)
      var  = dim_avg_n_Wrap(pre_diff_ssn,0)

  ;ttest
  ;GW_file="/home/ys17-19/cjx/CTRL_data/B2000_raw_data/B2000_f19g16_CP_CTRL.cam.h0.0252-02.nc"
  GW_IN=addfile(GW_file,"r")
  gw=GW_IN->gw
  siglvl = 0.05
  xtmp = pre_heat_ssn(lat |:,lon |:,time |:)
  ytmp = pre_ctrl_ssn(lat |:,lon |:,time |:)
  aveX = dim_avg(xtmp)
  aveY = dim_avg(ytmp)
  varX = dim_variance(xtmp)
  varY = dim_variance(ytmp)
  eqvX = equiv_sample_size(xtmp,siglvl,0)
  eqvY = equiv_sample_size(ytmp,siglvl,0)
  nX   = wgt_areaave(eqvX, gw, 1, 0)
  nY   = wgt_areaave(eqvY, gw, 1, 0)
  prob = pre_heat(0,:,:)
  prob = ttest(aveX, varX, nX, aveY, varY, nY, False, False)
  pre_diff_sig=var
  pre_diff_sig=mask(var, prob .lt. siglvl, True)
  ;printVarSummary(var)
  ;printVarSummary(prob)
  ;printVarSummary(pre_diff_sig)

    plot1 = new(1,"graphic")
    plot2 = new(1,"graphic")
   
  wks = gsn_open_wks("png",outfile)     
  gsn_define_colormap(wks,"BlueWhiteOrangeRed")
   
  res                 = True  
  res@gsnDraw         = False
  res@gsnFrame        = False
  res@gsnMaximize      = True       ; fill up the page
  res@gsnLeftString   = ""                   
  res@gsnRightString  = ""                 
  res@gsnCenterString = ""
;  res@gsnCenterStringFontHeightF = g_font  
   res@gsnPolar               = "NH"
   res@gsnPolarLabelFontHeightF = g_font
   res@mpCenterLonF = 110
   res@mpMaxLatF              = 30  
   res@mpFillOn               = False
   res@mpGeophysicalLineThicknessF = l_thick
   res@mpGridLineThicknessF   = l_thick
   res@mpLandFillColor        = "blue"
  res@mpGridSpacingF         = 30.     ;
  ;res@pmTickMarkDisplayMode = "Always"
  res@cnLevelSelectionMode  = "ManualLevels" ; set manual contour levels
;  res@cnLevels      =(/-400, -300,-1000,-100, 0, 100 ,400,800, 11000,1600,10000 /)
 ; res@cnFillColors =(/10,26,42,58,74,90,106,122,138,154,170,186,202,218,234,250/)
  res@cnFillColors =(/ 58, 74, 90, 122, 138, 170, 186, 202/)
  res@cnMinLevelValF        = -12         ; set min contour level
  res@cnMaxLevelValF        = 12         ; set max contour level
  res@cnLevelSpacingF       = 4          ; set contour interval
  res@cnFillOn      = True                  
  res@cnLinesOn     = False                 
  res@lbLabelFontHeightF = g_font
  ;res@mpMaxLatF=lat_N
  ;res@mpMinLatF=lat_S
  ;res@mpMaxLonF=lon_W
  ;res@mpMinLonF=lon_E

  res4                  = True       ; use plot options
  res4@lbLabelBarOn     = False
  res4@gsnLeftString   = ""                   
  res4@gsnRightString  = ""                 
  res4@gsnCenterString = " "
  res4@cnFillOn         = True       ; Fill contours
  res4@cnLinesOn        = False;True      ; turn off contour lines
  res4@gsnFrame         = False
  res4@gsnDraw  = False
  res4@cnLineLabelsOn   = False      ; turn off contour line labels
  res4@cnLineThicknessF = 2
  res4@cnLineColor      = "black"
  res4@cnInfoLabelOn = False
  res4@cnMonoFillPattern    = True;False
  res4@cnFillPattern = 17
  res4@cnMonoFillScale = True
  res4@cnFillScaleF = 1.
  res4@cnMonoFillColor = True
  res4@cnFillColor  =  "black"
  res4@cnFillDotSizeF = 0.004
 
  plot1 = gsn_csm_contour_map_polar(wks,var,res)
  plot2 = gsn_csm_contour(wks,pre_diff_sig,res4)
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
  ;print(aveX)
  ;print(xtmp)
end do
  delete(res)
  delete(res4)
  delete(level)
  ;delete(case_name)
end
