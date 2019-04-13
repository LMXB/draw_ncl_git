l_thick= 2
begin
lon_array=(/10.0, 115.0, 140.0, 155.0, 231.0,  284.0, 310.0/)
lat_array=(/0.0,  0.0,   -5.0,  5.0,   5.0,    0.0,   0.0/)
range=6
level=(/200,500,850,1000/)
do j=0,3,1
do i=1,1,1
  outfile="/home/ys17-19/cjx/figure/correlation-observation/olr(lon="+lon_array(i)+", lat="+lat_array(i)+") & z"+level(j)
  in_file1="/home/ys17-19/cjx/observation_data/olr.mon.mean.nc"
  fin_var1 = addfile(in_file1,"r")
  var1 = short2flt(fin_var1->olr(0:467:1,:,:))
  
  in_file2="/home/ys17-19/cjx/observation_data/ERA-Interim/era_interim_z.nc"
  fin_var2 = addfile(in_file2,"r")
  var2 = fin_var2->z(0:467:1,{level(j)},:,:)
  printVarSummary(var2)
  var2_ssn = month_to_season(short2flt(var2),"MAM")
  printVarSummary(var2_ssn)

  pre_var1 =var1(time|:,{lat | lat_array(i)-range:lat_array(i)+range},{lon | lon_array(i)+range:lon_array(i)+range})
  pre_var1_c=pre_var1
  pre_var1_c=pre_var1/24.0
  pre_var1_ssn = month_to_season(pre_var1_c,"MAM")
  printVarSummary(pre_var1_ssn)
  var1_reference = wgt_areaave(pre_var1_ssn,1.0,1.0,0)
  ;printVarSummary(var1_reference)
  ;print(var1_reference)
  r=var2_ssn(0,:,:)
  r=escorc(var2_ssn(latitude|:,longitude|:,time|:),var1_reference)
  ;print(r({latitude | lat_array(i)},{longitude | lon_array(i)}))
  
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
  
  wks = gsn_open_wks("png",outfile)
  gsn_define_colormap(wks,"BlueWhiteOrangeRed")
  res=True
  res@gsnDraw         = False
  res@gsnFrame        = False
  res@gsnLeftString   = "olr (lon="+lon_array(i)+", lat="+lat_array(i)+") & z"+level(j)+" correlation coefficient "                   
  res@gsnRightString  = " "                 
  res@gsnCenterString = " "
  res@cnLineThicknessF =3.
  res@cnLinesOn            = False
  res@cnFillOn             = True
  res@cnLevelSelectionMode = "ExplicitLevels"
  res@cnFillColors =(/2,17,33,49,97,145,193,209,225,241/)
  ;res@cnMinLevelValF        = -0.4         ; set min contour level
  ;res@cnMaxLevelValF        = 0.4         ; set max contour level
  ;res@cnLevelSpacingF       = 0.1          ; set contour interval
  res@cnLevels =(/-0.45,-0.4,-0.35,-0.3,0,0.3,0.35,0.4,0.45/)
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
  polyres@gsMarkerIndex     = 10          ; polymarker style
  polyres@gsMarkerSizeF     = 16.          ; polymarker size
  polyres@gsMarkerThicknessF     = 6.          ; polymarker size
  polyres@gsMarkerColor     = "green"          ; polymarker size
  plot1@$unique_string("fxxk ncl")$    = gsn_add_polymarker(wks,plot1,lon_array(i),lat_array(i),polyres)
  overlay(plot1,plot2)
  draw(plot1)
  frame(wks)
end do
end do
end
