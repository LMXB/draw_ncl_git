begin
;outfile="/home/ys17-19/cjx/precc/composite_analysis"
PRECC_file="/home/ys17-19/cjx/precc/MERRA_PRECC.1979-2015.nc"
fin_precc = addfile(PRECC_file,"r")
precc = fin_precc->PRECCON(:,:,:)
pre_precc =precc(TIME|:,{YDim | -10:10},{XDim | 105:125})
pre_precc_c=pre_precc
pre_precc_c=pre_precc*86400
pre_precc_ssn = month_to_season(pre_precc_c,"MAM")
printVarSummary(pre_precc_ssn)
sum_precc = wgt_areaave(pre_precc_ssn,1.0,1.0,0)
printVarSummary(sum_precc)
add=(sum(sum_precc(20:22))+sum(sum_precc(24:31)))/11.0-(sum(sum_precc(0:4))+sum(sum_precc(6:8)))/8.0
print(add)
;standardize=stddev(sum_precc)
;average    =avg(sum_precc)
;line1 =average+standardize
;line2 =average-standardize
;
;year=ispan(1979,2015,1)
;
;wks = gsn_open_wks("x11",outfile)
;res=True
;res@gsnDraw         = False
;res@gsnFrame        = False
;res@gsnYRefLine=line1
;res@xyLineThicknessF =3.
;res@tmXMajorGrid=True
;res@tmXMinorGridLineDashPattern =3
;res@tmXMinorGridThicknessF=0.3
;res@gsnYRefLineColor="red"
;res@gsnYRefLineDashPattern=16
;res@gsnYRefLineThicknessF=2.
;res@tmXMinorGrid=True
;
;;res@gsnYRefLine=line2
;
;res1=True
;res1@gsnDraw         = False
;res1@gsnFrame        = False
;res1@gsnYRefLine=line2
;res1@gsnYRefLineColor="red"
;res1@gsnYRefLineDashPattern=16
;res1@gsnYRefLineThicknessF=2.
;
;plot1 = new(1,"graphic")
;plot2 = new(1,"graphic")
;plot1 = gsn_csm_xy(wks,year,sum_precc,res)
;plot2 = gsn_csm_xy(wks,year,sum_precc,res1)
;overlay(plot1,plot2)
;draw(plot1)
;frame(wks)
end
