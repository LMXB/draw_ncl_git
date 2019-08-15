l_thick= 2
g_font = 0.025
FillValue = 999
siglvl = 0.05

begin
outfile="/home/ys17-19/cjx/figure/regression-observation/olr_aio"
in_file1="/home/ys17-19/cjx/observation_data/olr.mon.mean.nc"
fin_var1 = addfile(in_file1,"r")
var1 = fin_var1->olr(0:467:1,:,:)
printVarSummary(var1)
olr = month_to_season(short2flt(var1),"MAM")
printVarSummary(olr)

in_file2="/home/ys17-19/cjx/all_output_data/AOI/AOI.nc"
fin_var2 = addfile(in_file2,"r")
AOI = fin_var2->AOI
printVarSummary(AOI)

rc_AOI = regCoef_n(AOI,olr,0,0)
copy_VarCoords(olr(0,:,:),rc_AOI)
cor_AOI = escorc(olr(lat|:, lon|:, time|:), AOI)
copy_VarCoords(olr(0,:,:),cor_AOI)

;df_AOI = rc_AOI@nptxy-2
;tval_AOI = rc_AOI@tval
;prob_AOI_temp = student_t(tval_AOI,df_AOI)
;;printMinMax(prob_AOI_temp, 0)
;copy_VarCoords(olr(0,:,:),rc_AOI)
;;rc_AOI@FillValue = FillValue
;prob_AOI = onedtond(prob_AOI_temp, (/73, 144/)) 
;copy_VarCoords(olr(0,:,:),prob_AOI)
;;printMinMax(rc_AOI,0)
;rc_sig = where(prob_AOI .le. siglvl, rc_AOI, 32766)
;copy_VarCoords(olr(0,:,:),rc_sig)
;printVarSummary(rc_sig)
        
wks = gsn_open_wks("x11",outfile)
gsn_define_colormap(wks,"BlueWhiteOrangeRed")

res=True
res@gsnDraw         = False
res@gsnFrame        = False
res@gsnLeftString   = " "                   
res@gsnRightString  = " "                 
res@gsnCenterString = "OLR & AOI regression coefficient"
res@cnLineThicknessF =3.
res@cnLinesOn            = False
res@cnFillOn             = True
res@cnLevelSelectionMode = "ManualLevels"
res@cnFillColors =(/2,17,33,49,113,129,193,209,225,241/)
res@cnMinLevelValF        = -4         ; set min contour level
res@cnMaxLevelValF        = 4         ; set max contour level
res@cnLevelSpacingF       = 1          ; set contour interval
res@mpFillOn=False
res@mpCenterLonF =180
;res@mpMaxLatF=lat_N
;res@mpMinLatF=lat_S
;res@mpMaxLonF=lon_W
;res@mpMinLonF=lon_E
res@lbLabelFontHeightF = g_font
res@tmYLMajorLengthF=0.01
res@tmXBMajorLengthF=0.01
res@tmXBLabelFontHeightF = g_font
res@tmYLLabelFontHeightF = g_font
res@tmXBTickSpacingF =60
res@tmYLTickSpacingF =30
res@pmLabelBarOrthogonalPosF = 0.15
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
  res4@lbLabelBarOn     = False
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
  plot1 = gsn_csm_contour_map(wks,rc_AOI,res)
  plot2 = gsn_csm_contour_map(wks,cor_AOI,False)
  plot2 = gsn_contour_shade(plot2,-0.316,0.316,res4)
  overlay(plot1,plot2)
  draw(plot1)
  frame(wks)
end
