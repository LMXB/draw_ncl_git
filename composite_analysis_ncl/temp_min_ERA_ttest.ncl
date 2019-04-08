begin
  g_font = 0.025
    lat_N=80
    lat_S=-70
    lon_E=90
    lon_W=300
  l_thick= 2
  level=(/925,850,500,200/)
do i=0,3,1
  fils = "/home/ys17-19/cjx/observation_data/ERA-Interim/era_interim_t.nc" 
  outfile="/home/ys17-19/cjx/figure/composite_analysis_figure/ERA_temp_ttest_"+level(i)+"_min"
  fin_ctrl = addfiles(fils,"r")
  pre = short2flt(fin_ctrl[:]->t)
  pre_ctrl = pre(:,{level(i)},:,:)
;  pre_ctrl = fin_ctrl->H(120:359:1,{500},:,:)
  pre_ctrl_ssn = month_to_season(pre_ctrl,"MAM")
  ;printVarSummary(pre_ctrl_ssn)
  abnormal = (/2,4,8,12,14,18,36/)
  normal = (/0,1,3,5,6,7,9,10,11,13,15,16,17,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,37,38,39/)
  min_var=pre_ctrl_ssn(abnormal,:,:)
  min_var_ssn  = dim_avg_n_Wrap(min_var,0)
  var  = dim_avg_n_Wrap(pre_ctrl_ssn,0)
  var_diff = var
  var_diff = min_var_ssn-var
  
  nor_var=pre_ctrl_ssn(normal,:,:)

  ;ttest
  siglvl = 0.05
  xtmp = min_var(latitude |:,longitude |:,time |:)
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
  res@gsnCenterString = "min year T"+level(i)+" diff "
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
  res@cnMinLevelValF        = -1.2         ; set min contour level
  res@cnMaxLevelValF        = 1.2         ; set min contour level
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
  polyres                   = True
  polyres@gsMarkerIndex     = 10          ; polymarker style
  polyres@gsMarkerSizeF     = 16.          ; polymarker size
  polyres@gsMarkerThicknessF     = 6.          ; polymarker size
  polyres@gsMarkerColor     = "green"          ; polymarker size
  plot1@$unique_string("fxxk ncl")$    = gsn_add_polymarker(wks,plot1,115,0,polyres)
  overlay(plot1,plot2)
  draw(plot1)
  frame(wks)
end do
delete(res)
delete(res4)
delete(level)
delete(normal)
delete(abnormal)
delete(min_var)
delete(min_var_ssn)
delete(var)
delete(var_diff)
delete(nor_var)
end
