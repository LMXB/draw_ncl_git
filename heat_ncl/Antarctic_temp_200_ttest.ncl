begin
case_name="HEAT_F"
  g_font = 0.025
  l_thick= 2
  ;outfile="/home/ys17-19/cjx/figure/heat_test_figure/Antarctic_temp_200_ttest"
  outfile="/home/ys17-19/cjx/figure/"+case_name+"_figure/Antarctic_temp_200_ttest"
  HEAT_file="/home/ys17-19/cjx/all_output_data/"+case_name+"_output_data/MAM_HEAT.cam.h0.1-30.T.nc"
  ;HEAT_file="/home/ys17-19/cjx/all_output_data/HEAT_TEST_output_data/MAM_HEAT.cam.h0.1-30.T.nc"
  CTRL_file="/home/ys17-19/cjx/all_output_data/CTRL_output_data/CTRL.cam.h0.1-65.T.nc"
  fin_heat = addfile(HEAT_file,"r")
  fin_ctrl = addfile(CTRL_file,"r")
  pre_heat = fin_heat->T(120:359:1,{200},:,:)
  pre_ctrl = fin_ctrl->T(120:359:1,{200},:,:)
  pre_heat_ssn = month_to_season(pre_heat,"MAM")
  pre_ctrl_ssn = month_to_season(pre_ctrl,"MAM")
  pre_diff_ssn = pre_heat_ssn
  pre_diff_ssn = (pre_heat_ssn - pre_ctrl_ssn)
      var  = dim_avg_n_Wrap(pre_diff_ssn,0)
  
  ;ttest
  GW_file="/home/ys17-19/cjx/model-data/MAM_HEAT_TEST/MAM_HEAT_TEST.cam.h0.0015-12.nc"
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
  nX   = wgt_areaave(eqvX, 1, 1, 0)
  nY   = wgt_areaave(eqvY, 1, 1, 0)
  prob = pre_heat(0,:,:)
  ;print(min(varY))
  prob = ttest(aveX, varX, nX, aveY, varY, nY, False, False)
  pre_diff_sig=var
  pre_diff_sig=mask(var, prob .lt. siglvl, True)
  ;printVarSummary(var)
  ;printVarSummary(prob)
  ;printVarSummary(pre_diff_sig)

    plot1 = new(1,"graphic")
    plot2 = new(1,"graphic")
   
  wks = gsn_open_wks("png",outfile)     
  gsn_define_colormap(wks,"temp_diff_18lev")
   
  res                 = True  
  res@gsnDraw         = False
  res@gsnFrame        = False
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
;   res@mpLandFillColor        = "blue"
;  res@mpGridSpacingF         = 10.     ;
  ;res@pmTickMarkDisplayMode = "Always"
  res@cnLevelSelectionMode  = "ManualLevels" ; set manual contour levels
  res@cnFillColors =(/2, 4, 6, 8, 10, 11, 11, 13, 15, 17, 19, 20/)
 
  res@cnMinLevelValF        = -2.0         ; set min contour level
  res@cnMaxLevelValF        = 2.0         ; set max contour level
  res@cnLevelSpacingF       = 0.4          ; set contour interval
  res@cnFillOn      = True                  
  res@cnLinesOn     = False                 
  res@lbLabelFontHeightF = g_font

  res4                  = True       ; use plot options
  res4@cnFillOn         = True       ; Fill contours
  res4@cnLinesOn        = False;True      ; turn off contour lines
  res4@gsnFrame         = False
  res4@gsnDraw  = False
  res4@gsnLeftString   = " "                   
  res4@gsnRightString  = " "                 
  res4@gsnCenterString = " "
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
  overlay(plot1,plot2)
  draw(plot1)
  frame(wks)
  end
