begin
l_thick= 3
g_font = 0.025
u_file="/home/yangsong3/data-observation/NCEP_DOE/monthly/197901-201801/uwnd.mon.mean.nc"
v_file="/home/yangsong3/data-observation/NCEP_DOE/monthly/197901-201801/vwnd.mon.mean.nc"
fin_u = addfile(u_file,"r")
fin_v = addfile(v_file,"r")
uwnd = fin_u->uwnd(0:467:1,:,:,:)
printVarSummary(uwnd)
uwnd_ssn = month_to_season(short2flt(uwnd),"MAM")

vwnd = fin_v->vwnd(0:467:1,:,:,:)
printVarSummary(vwnd)
vwnd_ssn = month_to_season(short2flt(vwnd),"MAM")
;printVarSummary(vwnd_ssn)

in_file="/home/yangsong3/data-observation/NCEP_DOE/monthly/197901-201801/air.mon.mean.nc"
fin_air = addfile(in_file,"r")
air = fin_air->air(0:467:1,:,:,:)
printVarSummary(air)
air_ssn = month_to_season(short2flt(air),"MAM")

lat=uwnd&lat
plvl=uwnd&level
epf=epflux(uwnd,vwnd,air,plvl,lat,False)
printVarSummary(epf)
  Fphi=epf[0]
  Fp  =epf[1]
  EPdiv=epf[2]
  dudt =epf[3]

  wks = gsn_open_wks("png","./Fphi")        
  res                 = True  
  res@gsnDraw         = False
  res@gsnFrame        = False
  res@tmXBTickSpacingF =30
  ;res@tmYLTickSpacingF =30
  ;res@lbLabelFontHeightF = g_font
  res@cnLineLabelsOn   = False      ; turn off contour line labels
  res@gsnMaximize      = True       ; fill up the page
  res@gsnLeftString   = " "                   
  res@gsnRightString  = " "                 
  res@gsnCenterString = "E-P flux Fphi"
  res@gsnCenterStringFontHeightF = g_font  
  res@tiMainOn               = False
  res@tmXBLabelFontHeightF = g_font
  res@tmYLLabelFontHeightF = g_font
  ;res@trYLog               =True
  res@trYReverse           =True
  res@cnLineThicknessF     =l_thick
  res@gsnContourZeroLineThicknessF = 0
; ; res@mpGridSpacingF         = 10.     ;
  ;res@mpMaxLatF=lat_N
  ;res@mpMinLatF=lat_S
  ;res@mpMaxLonF=lon_W
  ;res@mpMinLonF=lon_E
  res@cnLinesOn     = True
  res@cnFillOn      = False
  res@cnInfoLabelOn = True
  res@cnLineLabelsOn= True
  res@cnLevelSelectionMode  = "ManualLevels" ; set manual contour levels
  res@cnMinLevelValF        = -100000        ; set min contour level
  res@cnMaxLevelValF        = 100000         ; set max contour level
  res@cnLevelSpacingF       = 5000          ; set contour interval
  plot  = gsn_csm_contour(wks,Fphi,res)
  plot = ColorNegDashZeroPosContour(plot, "black" ,"black", "red")
  draw(plot)
  frame(wks)

  ;wks = gsn_open_wks("png","./Fp")
  ;res@gsnCenterString = "E-P flux Fp"
  ;plot  = gsn_csm_contour(wks,Fp,res)
  ;plot = ColorNegDashZeroPosContour(plot, "black" ,"black", "red")
  ;draw(plot)
  ;frame(wks)

  ;wks = gsn_open_wks("png","./EPdiv")
  ;res@gsnCenterString = "E-P flux EPdiv"
  ;plot  = gsn_csm_contour(wks,EPdiv,res)
  ;plot = ColorNegDashZeroPosContour(plot, "black" ,"black", "red")
  ;draw(plot)
  ;frame(wks)

  ;wks = gsn_open_wks("png","./dudt")
  ;res@gsnCenterString = "E-P flux dudt"
  ;plot  = gsn_csm_contour(wks,dudt,res)
  ;plot = ColorNegDashZeroPosContour(plot, "black" ,"black", "red")
  ;draw(plot)
  ;frame(wks)
end
