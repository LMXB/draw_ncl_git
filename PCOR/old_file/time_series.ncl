begin
lon_array=(/10.0, 115.0, 140.0, 155.0, 231.0,  284.0, 310.0/)
lat_array=(/0.0,  0.0,   -5.0,  5.0,   5.0,    0.0,   0.0/)
range =10

do i=0,6,1
print(lon_array(i))
outfile="/home/ys17-19/cjx/GPCP/precip time_series in area (lon="+lon_array(i)+", lat="+lat_array(i)+")"
PRECC_file="/home/ys17-19/cjx/GPCP/gpcp_v02r03_monthly_197901_201901.nc"
fin_precc = addfile(PRECC_file,"r")
precc = fin_precc->precip(0:479:1,:,:)
pre_precc =precc(time|:,{latitude | lat_array(i)-range:lat_array(i)+range},{longitude | lon_array(i)-range:lon_array(i)+range})
pre_precc_c=pre_precc
pre_precc_c=pre_precc/24.0
pre_precc_ssn = month_to_season(pre_precc_c,"MAM")
printVarSummary(pre_precc_ssn)
sum_precc = wgt_areaave(pre_precc_ssn,1.0,1.0,0)
printVarSummary(sum_precc)

year=ispan(1979,2018,1)

wks = gsn_open_wks("png",outfile)
res=True
res@xyLineThicknessF =3.
res@vpHeightF=0.3
res@vpWidthF =0.8
res@vpXF=0.1
res@gsnCenterString = "precip time_series in area (lon="+lon_array(i)+", lat="+lat_array(i)+")"
res@trXMinF =1979
res@trXMaxF =2018
;res@tmXBTickSpacing =10
plot = gsn_csm_xy(wks,year,sum_precc,res)
end do
end
