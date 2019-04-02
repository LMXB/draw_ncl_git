level=(/1000,850,500,200/)
nlevel=dimsizes(level)
;print(nlevel)
l_thick= 2
;level(i)=500
begin
do i=0,nlevel-1,1
outfile="/home/ys17-19/cjx/figure/correlation-observation/climatological_Z"+level(i)
in_file="/home/yangsong3/data-observation/NCEP_DOE/monthly/197901-201801/hgt.mon.mean.nc"
fin_var = addfile(in_file,"r")
var_in = fin_var->hgt(0:467:1,{level(i)},:,:)
printVarSummary(var_in)
var_ssn = month_to_season(short2flt(var_in),"MAM")
printVarSummary(var_ssn)
var  = dim_avg_n_Wrap(var_ssn,0)

wks = gsn_open_wks("png",outfile)
gsn_define_colormap(wks,"BlueWhiteOrangeRed")
res=True
res@gsnDraw         = False
res@gsnFrame        = False
res@gsnLeftString   = "MAM climatologiCAL Z_"+level(i)+"hPa "                   
res@gsnRightString  = "NCEP_DOE"                 
res@gsnCenterString = " "
res@cnLineThicknessF =3.
res@cnLinesOn            = False
res@cnFillOn             = True
;res@cnLevelSelectionMode = "ManualLevels"
;res@cnFillColors =(/2,17,33,49,81,161,193,209,225,241/)
;res@cnMinLevelValF        = -0.8         ; set min contour level
;res@cnMaxLevelValF        = 0.8         ; set max contour level
;res@cnLevelSpacingF       = 0.2          ; set contour interval
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
  plot = gsn_csm_contour_map(wks,var,res)
  draw(plot)
  frame(wks)
end do
end
