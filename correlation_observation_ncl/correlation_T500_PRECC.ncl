l_thick= 2
begin
outfile="/home/ys17-19/cjx/figure/MERRA_figure/correlation_T500&PRECC"
PRECC_file="/home/ys17-19/cjx/precc/MERRA_PRECC.1979-2015.nc"
fin_precc = addfile(PRECC_file,"r")
precc = fin_precc->PRECCON(:,:,:)
precc_ssn = month_to_season(precc,"MAM")
printVarSummary(precc_ssn)
precc_reference=precc_ssn({YDim | 0.625},{XDim | 115.625},TIME|:)
;printVarSummary(precc_reference)
;print(precc_reference)
  fils = systemfunc("ls /home/ys17-19/cjx/MERRA/MERRA*.nc") 
  setfileoption("nc","SuppressClose",False) ; close too many files
  fin_ctrl = addfiles(fils,"r")
  T = fin_ctrl[:]->T(:,{500},:,:)
pre_T_ssn = month_to_season(T,"MAM")
printVarSummary(pre_T_ssn)
r=pre_T_ssn(0,:,:)
printVarSummary(r)
r=escorc(pre_T_ssn(YDim|:,XDim|:,TIME|:),precc_reference)



r_sig_level=0.325   ;  siglvl = 0.05
;  xtmp = pre_T_ssn(YDim |:,XDim |:,TIME |:)
;  ytmp = precc_reference
;  aveX = dim_avg(xtmp)
;  aveY = dim_avg(ytmp)
;  varX = dim_variance(xtmp)
;  varY = dim_variance(ytmp)
;  eqvX = equiv_sample_size(xtmp,siglvl,0)
;  eqvY = equiv_sample_size(ytmp,siglvl,0)
;  nX   = wgt_areaave(eqvX, 1, 1, 0)
;  nY   = wgt_areaave(eqvY, 1, 1, 0)
;  prob = pre_T_ssn(0,:,:)
;  prob = ttest(aveX, varX, nX, aveY, varY, nY, False, False)
;  pre_diff_sig=var
;  pre_diff_sig=mask(var, prob .lt. siglvl, True)
  ;printVarSummary(var)
  ;printVarSummary(prob)
  ;printVarSummary(pre_diff_sig)
pre_diff_sig=pre_T_ssn(0,:,:)
pre_diff_sig=mask(r, abs(r) .gt. r_sig_level,True)

wks = gsn_open_wks("png",outfile)
gsn_define_colormap(wks,"BlueWhiteOrangeRed")
res=True
res@gsnDraw         = False
res@gsnFrame        = False
res@gsnLeftString   = "T_500hPa & precc(0.625N,115E) correlation coefficient "                   
res@gsnRightString  = "MERRA"                 
res@gsnCenterString = " "
res@cnLineThicknessF =3.
res@cnLinesOn            = False
res@cnFillOn             = True
res@cnLevelSelectionMode = "ManualLevels"
res@cnFillColors =(/1,17,33,49,81,161,193,209,225,241/)
res@cnMinLevelValF        = -0.8         ; set min contour level
res@cnMaxLevelValF        = 0.8         ; set max contour level
res@cnLevelSpacingF       = 0.2          ; set contour interval
res@mpFillOn=False
;res@tmXMajorGrid=True
;res@tmXMinorGridLineDashPattern =3
;res@tmXMinorGridThicknessF=0.3
;res@tmXBMode="Manual"
;res@tmXBTickStartF=1979
;res@tmXBTickEndF=2015
;res@tmXBLabelFontHeightF =0.021
res@mpGeophysicalLineThicknessF =l_thick
;res@txString ="significant level = 0.05"
;res@txPosXF=0.5
;res@txPosYF =0.5
    plot1 = new(1,"graphic")
    plot2 = new(1,"graphic")
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
  res4@lbLabelBarOn =False
  plot1 = gsn_csm_contour_map(wks,r,res)
  plot2 = gsn_csm_contour(wks,pre_diff_sig,res4)
  overlay(plot1,plot2)
  draw(plot1)
  frame(wks)
end
