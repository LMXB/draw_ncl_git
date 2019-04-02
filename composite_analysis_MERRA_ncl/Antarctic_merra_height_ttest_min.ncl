begin
  g_font = 0.025
  l_thick= 2
level=(/925,850,500,200/)
do i=0,0,1
  fils = systemfunc("ls /home/ys17-19/cjx/MERRA/MERRA*.hdf.nc") 
  outfile="/home/ys17-19/cjx/figure/MERRA_figure/Antarctic_MERRA_height_ttest_"+level(i)+"_min"
 ; print(fils)
  setfileoption("nc","SuppressClose",False) ; close too many files
  fin_ctrl = addfiles(fils,"r")
  pre = fin_ctrl[:]->H
  pre_ctrl = pre(:,{level(i)},:,:)
;  pre_ctrl = fin_ctrl->H(120:359:1,{500},:,:)
  pre_ctrl_ssn = month_to_season(pre_ctrl,"MAM")
  printVarSummary(pre_ctrl_ssn)
  idx = (/1,2,4,8,32,36/)
  cp_var=pre_ctrl_ssn(idx,:,:)
  var_cp  = dim_avg_n_Wrap(cp_var,0)
  var  = dim_avg_n_Wrap(pre_ctrl_ssn,0)
  var_diff = var
  var_diff = var_cp-var
  
  ;ttest
  siglvl = 0.05
  xtmp = cp_var(YDim |:,XDim |:,TIME |:)
  ytmp = pre_ctrl_ssn(YDim |:,XDim |:,TIME |:)
  aveX = dim_avg(xtmp)
  aveY = dim_avg(ytmp)
  varX = dim_variance(xtmp)
  varY = dim_variance(ytmp)
  eqvX = equiv_sample_size(xtmp,siglvl,0)
  eqvY = equiv_sample_size(ytmp,siglvl,0)
  nX   = wgt_areaave(eqvX, 1, 1, 0)
  nY   = wgt_areaave(eqvY, 1, 1, 0)
  prob = pre_ctrl(0,:,:)
  print(prob)
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
  res@gsnLeftString   = " "                   
  res@gsnFrame         = False
  res@gsnDraw  = False
  res@gsnRightString  = " "                 
   res@gsnCenterString = " "
;  res@gsnCenterStringFontHeightF = 0.05  
   res@gsnPolar              = "SH"
   res@mpMaxLatF            = -45  

   res@gsnPolarLabelFontHeightF = g_font
   res@mpGeophysicalLineThicknessF = l_thick
   res@mpGridLineThicknessF   = l_thick
 ; res@pmTickMarkDisplayMode = "Always"
  
  ;res@pmTickMarkDisplayMode = "Always"
  res@cnLevelSelectionMode  = "ManualLevels" ; set manual contour levels
;  res@cnLevels      =(/-400, -300,-200,-100, 0, 100 ,400,800, 1200,1600,2000 /)
 ; res@cnFillColors =(/10,26,42,58,74,90,106,122,138,154,170,186,202,218,234,250/)
  res@cnFillColors =(/218, 202, 186, 170, 138, 122, 90, 74, 58, 42, 26 ,10/)
  res@cnMinLevelValF        = -80         ; set min contour level
  res@cnMaxLevelValF        = 120         ; set max contour level
  res@cnLevelSpacingF       = 20          ; set contour interval
  res@cnFillOn      = True                  
  res@cnLinesOn     = False                 
  res@lbLabelFontHeightF = g_font
  res@mpFillOn               = False         
;  res@mpGridSpacingF         = 10.     ;

  
  res4                  = True       ; use plot options
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
  plot1 = gsn_csm_contour_map_polar(wks,var_diff,res)
  plot2 = gsn_csm_contour(wks,pre_diff_sig,res4)
  overlay(plot1,plot2)
  draw(plot1)
  frame(wks)
end do
end
