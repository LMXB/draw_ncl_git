   ; lon_array=(/10.0, 115.0, 140.0, 155.0, 231.0,  284.0, 310.0/)
   ; lat_array=(/0.0,  0.0,   -5.0,  5.0,   5.0,    0.0,   0.0/)
begin
;do i=0,0,1
outfile="/home/ys17-19/cjx/figure/regression-zonal_mean/lon="+lon_array(i)+"/regression_precip"
in_file="/home/ys17-19/cjx/GPCP/gpcp_v02r03_monthly_197901_201901.nc"
fin_var = addfile(in_file,"r")
var = fin_var->precip(0:479:1,:,:)
printVarSummary(var)
var_ssn = month_to_season(dim_rmvmean_Wrap(var),"MAM")
printVarSummary(var_ssn)
var_reference=var_ssn({latitude | lat_array(i)},{longitude | lon_array(i)},time|:)
;printVarSummary(var_reference)
;print(var_reference)
r=var_ssn(0,:,:)
r=(/regCoef_n(var_reference,var_ssn,0,0)/)
print(r({latitude | lat_array(i)},{longitude | lon_array(i)}))

siglvl = 0.05
prob=rtest(r,num(var_ssn(:,0,0)),0)
sig=var_ssn(0,:,:)
sig=mask(r, prob .lt.siglvl, True)

wks = gsn_open_wks("png",outfile)
gsn_define_colormap(wks,"BlueWhiteOrangeRed")
res=True
res@gsnDraw         = False
res@gsnFrame        = False
;res@gsnLeftString   = "precip & (lon="+lon_array(i)+", lat="+lat_array(i)+") correlation coefficient "                   
res@gsnLeftString   = " "                   
res@gsnRightString  = " "                 
res@gsnCenterString = "precip(-zonal mean) regression coefficient "
res@cnLineThicknessF =3.
res@cnLinesOn            = False
res@cnFillOn             = True
res@cnLevelSelectionMode = "ManualLevels"
res@cnFillColors =(/2,17,33,49,113,129,193,209,225,241/)
res@cnMinLevelValF        = -0.8         ; set min contour level
res@cnMaxLevelValF        = 0.8         ; set max contour level
res@cnLevelSpacingF       = 0.2          ; set contour interval
res@mpFillOn=False
res@mpCenterLonF =180
res@mpMaxLatF=lat_N
res@mpMinLatF=lat_S
res@mpMaxLonF=lon_W
res@mpMinLonF=lon_E
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
  res4@lbLabelBarOn     = False
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
  plot2 = gsn_csm_contour(wks,sig,res4)
  polyres                   = True
  polyres@gsMarkerIndex     = 10          ; polymarker style
  polyres@gsMarkerSizeF     = 16.          ; polymarker size
  polyres@gsMarkerThicknessF     = 6.          ; polymarker size
  polyres@gsMarkerColor     = "green"          ; polymarker size
  plot1@$unique_string("fxxk ncl")$    = gsn_add_polymarker(wks,plot1,lon_array(i),lat_array(i),polyres)
  overlay(plot1,plot2)
  draw(plot1)
  frame(wks)
 ; end do
delete(r)
delete(prob)
delete(sig)
delete(res)
delete(res4)
end
