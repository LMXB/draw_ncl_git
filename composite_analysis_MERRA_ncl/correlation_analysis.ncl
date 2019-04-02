begin
PRECC_file="/home/ys17-19/cjx/precc/MERRA_PRECC.1979-2015.nc"
fin_precc = addfile(PRECC_file,"r")
precc = fin_precc->PRECCON(:,:,:)
pre_precc_c =precc(TIME|:,{YDim | -10:10},{XDim | 105:125})
pre_precc_ssn = month_to_season(pre_precc_c,"MAM")
printVarSummary(pre_precc_ssn)
sum_precc = wgt_areaave(pre_precc_ssn,1.0,1.0,0)
sta_precc= sum_precc
sta_precc= (sum_precc-avg(sum_precc))/stddev(sum_precc)
;print(sum_precc)

  fils = systemfunc("ls /home/ys17-19/cjx/MERRA/MERRA*.nc") 
  outfile="/home/ys17-19/cjx/draw_ncl/MERRA_ncl/correlation_analysis"
;  print(fils)
  setfileoption("nc","SuppressClose",False) ; close too many files
  fin_ctrl = addfiles(fils,"r")
  T = fin_ctrl[:]->T(:,{500},:,:)
pre_T =T(TIME|:,{YDim | -90:-50},{XDim | -180:0})
pre_T_ssn = month_to_season(pre_T,"MAM")
printVarSummary(pre_T_ssn)
sum_T = wgt_areaave(pre_T_ssn,1.0,1.0,0)
;print(sum_T)
sta_T= sum_T
sta_T= (sum_T-avg(sum_T))/stddev(sum_T)
r=escorc(sum_T,sum_precc)
print("correlation="+r)

year=ispan(1979,2015,1)

wks = gsn_open_wks("x11",outfile)
res=True
res@gsnDraw         = False
res@gsnFrame        = False
res@xyLineColor="red"
res@xyLineThicknessF =3.
;res@tmXMajorGrid=True
;res@tmXMinorGridLineDashPattern =3
;res@tmXMinorGridThicknessF=0.3
res@tmXBMode="Manual"
res@tmXBTickStartF=1979
res@tmXBTickEndF=2015
res@tmXBLabelFontHeightF =0.021

res1=True
res1@gsnDraw         = False
res1@gsnFrame        = False
res1@xyLineThicknessF =3.
res1@xyLineColor="blue"

plot1 = new(1,"graphic")
plot2 = new(1,"graphic")
plot1 = gsn_csm_xy(wks,year,sta_precc,res)
plot2 = gsn_csm_xy(wks,year,sta_T,res1)
overlay(plot1,plot2)
draw(plot1)
frame(wks)
end
