begin
  level=(/500,400,300,250,200,150,100,50/)
  ;case_name="HEAT_F"
  g_font = 0.025
  l_thick= 2
  wks = gsn_open_wks("png","/home/ys17-19/cjx/figure/error")     
  gsn_define_colormap(wks,"BlueWhiteOrangeRed")
  plot1 = new((/8/),graphic)
  plot2 = new((/8/),graphic)
  ;outfile="/home/ys17-19/cjx/figure/"+case_name+"_figure/"+season+" global_temp_"+level(i)+"_ttest"
  ;HEAT_file="/home/ys17-19/cjx/all_output_data/HEAT_MC_output/HEAT_MC.cam.h0.250-289.nc"
  HEAT_file="/home/ys17-19/cjx/all_output_data/"+case_name+"_output/"+case_name+".cam.h0.250-289.nc"
  ;CTRL_file="/home/ys17-19/cjx/all_output_data/B2000_CTRL_output/B2000_f19g16_CP_CTRL.cam.h0.250-289.nc"
  fin_heat = addfile(HEAT_file,"r")
  fin_ctrl = addfile(CTRL_file,"r")

  res                 = True  
  res@gsnDraw         = False
  res@gsnFrame        = False
  res@gsnMaximize      = True       ; fill up the page
  res@gsnLeftString   = ""                   
  res@gsnRightString  = ""                 
  res@mpCenterLonF = 180.
;  res@gsnCenterStringFontHeightF = g_font  
   res@mpFillOn               = False
   res@mpGeophysicalLineThicknessF = l_thick
   res@mpGridLineThicknessF   = l_thick
;   res@mpLandFillColor        = "blue"
;  res@mpGridSpacingF         = 10.     ;
  ;res@pmTickMarkDisplayMode = "Always"
  res@cnLevelSelectionMode  = "ManualLevels" ; set manual contour levels
;  res@cnLevels      =(/-400, -300,-1000,-100, 0, 100 ,400,800, 11000,1600,10000 /)
 ; res@cnFillColors =(/10,26,42,58,74,90,106,122,138,154,170,186,202,218,234,250/)
  res@cnFillColors =(/ 42, 58, 74, 90, 96, 144, 170, 186, 202, 218/)
  res@cnMinLevelValF        = -0.8         ; set min contour level
  res@cnMaxLevelValF        = 0.8         ; set max contour level
  res@cnLevelSpacingF       = 0.2          ; set contour interval
  res@cnFillOn      = True                  
  res@cnLinesOn     = False
  res@lbLabelBarOn  = False
  res@lbLabelFontHeightF = g_font
  res@tmYLMajorLengthF=0.01
  res@tmXBMajorLengthF=0.01
  res@tmXBLabelFontHeightF = g_font
  res@tmYLLabelFontHeightF = g_font
  res@tmXBTickSpacingF =60
  res@tmYLTickSpacingF =30
  res@pmLabelBarOrthogonalPosF = 0.15
  res@mpMaxLatF=lat_N
  res@mpMinLatF=lat_S
  res@mpMaxLonF=lon_W
  res@mpMinLonF=lon_E

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

  polyres                   = True
  polyres@gsMarkerIndex     = 10          ; polymarker style
  polyres@gsMarkerSizeF     = 16.          ; polymarker size
  polyres@gsMarkerThicknessF     = 6.          ; polymarker size
  polyres@gsMarkerColor     = "green"          ; polymarker size

  do i=0,7,1
    pre_heat = fin_heat->T(120:479:1,{level(i)},:,:)
    pre_ctrl = fin_ctrl->T(120:479:1,{level(i)},:,:)
    pre_heat_ssn = month_to_season(pre_heat,season)
    pre_ctrl_ssn = month_to_season(pre_ctrl,season)
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
 
    res@gsnCenterString = season+" T"+level(i)+" Diff "
 
    plot1(i) = gsn_csm_contour_map(wks,var,res)
    plot2(i) = gsn_csm_contour(wks,pre_diff_sig,res4)
 ;   plot = gsn_csm_contour_map_polar(wks,pre_diff_sig,res4)
    plot1@$unique_string("fxxk ncl")$    = gsn_add_polymarker(wks,plot1(i),lon_array(j),lat_array(j),polyres)
    overlay(plot1(i),plot2(i))
    ;print(aveX)
    ;print(xtmp)
    print(i+" "+level(i))
  end do

  pres= True
  pres@gsnPanelLabelBar   = True      ;Universial colorbar
  pres@lbLabelFontHeightF = 0.012
  
  gsn_panel(wks,plot1,(/4,2/),pres)
  delete(level)
  delete(res)
  delete(res4)
  ;delete(case_name)
end
