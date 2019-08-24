l_thick= 2
begin
lon_array = 210
lat_array = -75
range = 15
g_strt_mon = 198001
g_lst_mon = 201012

outfile="/home/ys17-19/cjx/figure/correlation-observation/Ross_sea_SIC&OLR"
in_file1="/home/ys17-19/cjx/observation_data/SIC/MERRA2_SIC.nc"
fin_var1 = addfile(in_file1,"r")
time_hist    = fin_var1->time
yyyymm  = cd_calendar(time_hist,-1)
istrt   = ind(yyyymm .eq. g_strt_mon)
ilast   = ind(yyyymm .eq. g_lst_mon)
var1 = fin_var1->SIC(istrt:ilast,:,:)
;printVarSummary(var1)
var1_ssn = month_to_season(var1,"MAM")
var1_dtrend = dtrend_msg_n(var1_ssn&time, var1_ssn, False, False, 0)
copy_VarCoords(var1(0:dimsizes(var1_ssn(:,0,0))-1, :, :), var1_dtrend)
;printVarSummary(var1_dtrend)
delete(var1)

in_file2="/home/ys17-19/cjx/observation_data/olr.mon.mean.nc"
fin_var2 = addfile(in_file2,"r")
time_hist   := fin_var2->time
yyyymm  := cd_calendar(time_hist,-1)
istrt   := ind(yyyymm .eq. g_strt_mon)
ilast   := ind(yyyymm .eq. g_lst_mon)
var2 = fin_var2->olr(istrt:ilast,:,:)
printVarSummary(var2)
var2_ssn = month_to_season(short2flt(var2),"MAM")
var2_dtrend = dtrend_msg_n(var2_ssn&time, var2_ssn, False, False, 0) 
copy_VarCoords(var2(0:dimsizes(var2_ssn(:,0,0))-1, :, :), var2_dtrend)
printVarSummary(var2_dtrend)
delete(var2)

pre_var1 =var1_dtrend(:,{lat_array-range:lat_array+range},{lon_array+range:lon_array+range})
;printVarSummary(pre_var1_ssn)
var1_reference = wgt_areaave(pre_var1, 1.0, 1.0, 0)
;print(var1_reference)
r=var2_ssn(0,:,:)
r=escorc(var2_dtrend(lat |:,lon |:,time|:),var1_reference)
printVarSummary(r)
grid = 2.5
line = 30
r_tropic = r({line:0-line},{0:360})
dims = dimsizes(r_tropic(:,:)) 
ij= ind_resolve(maxind(ndtooned(r_tropic(:,:))),dims(0:1))
lat_location = -ij(0,0)*grid+line
lon_location = ij(0,1)*grid
print("lon="+lon_location+" lat="+lat_location)

r_sig_level=0.312;  siglvl = 0.05
;  xtmp = pre_T_ssn(lat |:,lon |:,time |:)
;  ytmp = var1_reference
;  aveX = dim_avg(xtmp)
;  aveY = dim_avg(ytmp)
;  var1X = dim_var1iance(xtmp)
;  var1Y = dim_var1iance(ytmp)
;  eqvX = equiv_sample_size(xtmp,siglvl,0)
;  eqvY = equiv_sample_size(ytmp,siglvl,0)
;  nX   = wgt_areaave(eqvX, 1, 1, 0)
;  nY   = wgt_areaave(eqvY, 1, 1, 0)
;  prob = pre_T_ssn(0,:,:)
;  prob = ttest(aveX, var1X, nX, aveY, var1Y, nY, False, False)
;  pre_diff_sig=var1
;  pre_diff_sig=mask(var1, prob .lt. siglvl, True)
  ;printVarSummary(var1)
  ;printVarSummary(prob)
  ;printVarSummary(pre_diff_sig)
sig=var2_ssn(0,:,:)
sig=mask(r, abs(r) .gt. r_sig_level,True)

wks = gsn_open_wks("x11",outfile)
gsn_define_colormap(wks,"BlueWhiteOrangeRed")
res=True
res@gsnDraw         = False
res@gsnFrame        = False
res@gsnLeftString   = "OLR & ROSS_SEA SIC correlation coefficient "                   
res@gsnRightString  = " "                 
res@gsnCenterString = " "
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
  plot2 = gsn_csm_contour(wks,sig,res4)
  polyres                   = True
  polyres@gsMarkerIndex     = 2          ; polymarker style
  polyres@gsMarkerSizeF     = 16.          ; polymarker size
  polyres@gsMarkerThicknessF     = 6.          ; polymarker size
  polyres@gsMarkerColor     = "purple"          ; polymarker size
  ;plot1@$unique_string("fxxk ncl")$    = gsn_add_polymarker(wks,plot1,lon_array,lat_array,polyres)
  plot1@$unique_string("fxxk ncl")$    = gsn_add_polymarker(wks,plot1,lon_location,lat_location,polyres)
  overlay(plot1,plot2)
  draw(plot1)
  frame(wks)
end
