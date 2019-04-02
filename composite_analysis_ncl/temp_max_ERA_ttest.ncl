begin
  g_font = 0.025
  lat_N=70
  lat_S=-70
  lon_E=90
  lon_W=280
  l_thick= 2
  level=(/925,850,500,200/)
do i=0,3,1
  fils = "/home/ys17-19/cjx/observation_data/ERA-Interim/era_interim_t.nc" 
  outfile="/home/ys17-19/cjx/figure/composite_analysis_figure/ERA_height_ttest_"+level(i)+"_max"
  fin_ctrl = addfiles(fils,"r")
  pre = short2flt(fin_ctrl[:]->t)
  pre_ctrl = pre(:,{level(i)},:,:)
;  pre_ctrl = fin_ctrl->H(120:359:1,{500},:,:)
  pre_ctrl_ssn = month_to_season(pre_ctrl,"MAM")
  ;printVarSummary(pre_ctrl_ssn)
  abnormal = (/7,22,26,30,33,38/)
  normal = (/0,1,2,3,4,5,6,8,9,10,11,12,13,14,15,16,17,18,19,20,21,23,24,25,27,28,29,31,32,34,35,36,37,39/)
  max_var=pre_ctrl_ssn(abnormal,:,:)
  var_max  = dim_avg_n_Wrap(max_var,0)
  var  = dim_avg_n_Wrap(pre_ctrl_ssn,0)
  var_diff = var
  var_diff = var_max-var
  
  nor_var=pre_ctrl_ssn(normal,:,:)

  ;ttest
  siglvl = 0.05
  xtmp = max_var(latitude |:,longitude |:,time |:)
  ytmp = nor_var(latitude |:,longitude |:,time |:)
  aveX = dim_avg(xtmp)
  aveY = dim_avg(ytmp)
  varX = dim_variance(xtmp)
  varY = dim_variance(ytmp)
  eqvX = equiv_sample_size(xtmp,siglvl,0)
  eqvY = equiv_sample_size(ytmp,siglvl,0)
  nX   = wgt_areaave(eqvX, 1, 1, 0)
  nY   = wgt_areaave(eqvY, 1, 1, 0)
  prob = pre_ctrl(0,:,:)
  ;print(prob)
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
  res@gsnCenterString = "MAX Year T"+level(i)+" Diff "
  res@mpCenterLonF = 180.
;  res@gsnCenterStringFontHeightF = g_font  
   res@mpFillOn               = False
   res@mpGeophysicalLineThicknessF = l_thick
   res@mpGridLineThicknessF   = l_thick
;   res@mpLandFillColor        = "blue"
;  res@mpGridSpacingF         = 10.     ;
  ;res@pmTickMarkDisplayMode = "Always"
  res@cnLevelSelectionMode  = "ManualLevels" ; set manual contour levels
  res@cnFillColors =(/42, 58, 74, 90, 122, 138, 170, 186, 202,218/)
  res@cnMinLevelValF        = -1.2         ; set max contour level
  res@cnMaxLevelValF        = 1.2         ; set max contour level
  res@cnLevelSpacingF       = 0.3          ; set contour interval
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

  plot1 = gsn_csm_contour_map(wks,var_diff,res)
  plot2 = gsn_csm_contour(wks,pre_diff_sig,res4)
  overlay(plot1,plot2)
  draw(plot1)
  frame(wks)
end do
end
