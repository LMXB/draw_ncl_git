l_thick= 2
g_font = 0.025
begin
outfile="/home/ys17-19/cjx/figure/regression-observation/lon="+lon_array(i)+"/regression_uwnd200"
u_file="/home/yangsong3/data-observation/NCEP_DOE/monthly/197901-201801/uwnd.mon.mean.nc"
fin_u = addfile(u_file,"r")

uwnd = fin_u->uwnd(0:467:1,{200},:,:)
;printVarSummary(uwnd)
uwnd_ssn = month_to_season(short2flt(uwnd),"MAM")
;printVarSummary(uwnd_ssn)
uwnd_reference=uwnd_ssn({lat | lat_array(i)},{lon | lon_array(i)},time|:)
;printVarSummary(uwnd_reference)
;;print(uwnd_reference)
rc_uwnd=uwnd_ssn(0,:,:)
rc_uwnd=(/regCoef_n(uwnd_reference,uwnd_ssn,0,0)/)
;printVarSummary(rc_uwnd)
;;print(rc_uwnd)
;print(rc_uwnd({lat | 0.0},{lon | 115.0}))

siglvl = 0.05
sig=uwnd_ssn(0,:,:)
prob=rtest(rc_uwnd,num(uwnd_ssn(:,0,0)),0)
sig=mask(rc_uwnd, prob .lt.siglvl, True)

  wks = gsn_open_wks("png",outfile)     
  gsn_define_colormap(wks,"BlueWhiteOrangeRed")
   
  res                 = True  
  res@gsnDraw         = False
  res@gsnFrame        = False
  res@lbLabelFontHeightF = g_font
  res@tmXBLabelFontHeightF = g_font
  res@tmYLLabelFontHeightF = g_font
  res@tmXBTickSpacingF =60
  res@tmYLTickSpacingF =30
  res@cnLineLabelsOn   = False      ; turn off contour line labels
  res@gsnMaximize      = True       ; fill up the page
  res@gsnLeftString   = " "                   
  res@gsnRightString  = " "                 
  res@gsnCenterString = " "
   ;  res@gsnCenterStringFontHeightF = g_font  
  res@cnLevelSelectionMode = "ManualLevels"
  res@cnFillColors =(/2,17,33,49,113,129,193,209,225,241/)
  res@cnMinLevelValF        = -0.8         ; set min contour level
  res@cnMaxLevelValF        = 0.8         ; set max contour level
  res@cnLevelSpacingF       = 0.2          ; set contour interval
  res@mpFillOn               = False
  res@mpCenterLonF           =180
  res@mpGeophysicalLineThicknessF = l_thick
  res@mpGridLineThicknessF   = l_thick
  res@cnLinesOn        = False;True      ; turn off contour lines
  res@cnFillOn         = True       ; Fill contours
  res@pmLabelBarOrthogonalPosF = 0.15
  res@mpMaxLatF=lat_N
  res@mpMinLatF=lat_S
  res@mpMaxLonF=lon_W
  res@mpMinLonF=lon_E

  
  res4                  = True       ; use plot options
  res4@cnFillOn         = False;True       ; Fill contours
  res4@cnLinesOn        = False;True      ; turn off contour lines
  res4@gsnFrame         = False
  res4@gsnDraw  = False
  res4@gsnLeftString   = " "                   
  res4@gsnRightString  = " "                 
  res4@gsnCenterString = " "
  res4@cnLineThicknessF = 2
  res4@cnLineColor      = "black"
  res4@cnInfoLabelOn = False
  res4@cnLineLabelsOn   = False      ; turn off contour line labels
  res4@cnMonoFillPattern    = True
  res4@cnFillPattern = 17
  res4@cnMonoFillScale = True
  res4@cnFillScaleF = 1.
  res4@cnMonoFillColor = True
  res4@cnFillDotSizeF = 0.004
  res4@cnFillOn     = True
  ;res4@cnLevelSelectionMode ="ExplicitLevels"
  ;res4@cnLevels     = (/0,1/)
  ;res4@cnFillColor  = (/229,229,229/)
  res4@cnFillColor  = "black"
  res4@cnFillOpacityF=0.5
  res4@lbLabelBarOn     = False
  

  plot1 = gsn_csm_contour_map(wks,rc_uwnd,res)
  plot2 = gsn_csm_contour(wks,sig,res4)
;  plot  = gsn_csm_vector_map_polar(wks,u,v,res)
  polyres                   = True
  polyres@gsMarkerIndex     = 10          ; polymarker style
  polyres@gsMarkerSizeF     = 16.          ; polymarker size
  polyres@gsMarkerThicknessF     = 6.          ; polymarker size
  polyres@gsMarkerColor     = "green"          ; polymarker size
  plot1@$unique_string("fxxk ncl")$    = gsn_add_polymarker(wks,plot1,lon_array(i),lat_array(i),polyres)
  overlay(plot1,plot2)
  draw(plot1)
  frame(wks)
delete(rc_uwnd)
delete(prob)
delete(sig)
delete(res)
delete(res4)
end
