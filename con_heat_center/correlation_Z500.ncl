l_thick= 2
begin
outfile="/home/ys17-19/cjx/figure/correlation-observation/multi_center/correlation_Z500"
in_file="/home/yangsong3/data-observation/NCEP_DOE/monthly/197901-201801/hgt.mon.mean.nc"
fin_var = addfile(in_file,"r")
var = fin_var->hgt(0:467:1,{500},:,:)
printVarSummary(var)
var_ssn = month_to_season(short2flt(var),"MAM")
printVarSummary(var_ssn)

;--------------counting var reference------
    g_data_path ="/home/ys17-19/data-observation/PREC/GPCP_precip.mon.mean.nc"
    g_strt_mon = 197901 
    g_lst_mon = 201412

	ctrl_file1   = g_data_path
	ctrl_in1     = addfile (ctrl_file1, "r")   ; note the "s" of addfile
	time_hist    = ctrl_in1->time
    yyyymm  = cd_calendar(time_hist,-1)
    istrt   = ind(yyyymm .eq. g_strt_mon)
    ilast   = ind(yyyymm .eq. g_lst_mon)
	var1  =ctrl_in1->precip(istrt:ilast,:,:)			; p for unify the var name

    var1_ssn = month_to_season(var1,"MAM")

    var1_ssn_mean=dim_avg_n_Wrap(var1_ssn,0)

    printVarSummary(var1_ssn_mean)

    ; spring
    lon_array=(/10.0, 115.0, 140.0, 155.0, 231.0,  284.0, 310.0/)
    lat_array=(/0.0,  0.0,   -5.0,  5.0,   5.0,    0.0,   0.0/)

    ; summer
    ;lon_array=(/90.0, 140.0, 250.0, 295.0, 345.0,  10.0/)
    ;lat_array=(/20.0, 5.0,   10.0,  5.0,   10.0,  5.0/)
    
    ; winter
    ;lon_array=(/110.0, 140.0,  175.0, 300.0,  47.5/)
    ;lat_array=(/0.0,   -5.0,   -10.0, -7.5,   -17.5/)
    
    ; autumn
    ;lon_array=(/100.0, 140.0,  220.0, 280.0,  330.0, 10.0/)
    ;lat_array=(/0.0,   -5.0,   7.5,   5.0,    7.5,   0.0/)
    

    dimlon=dimsizes(lon_array) 

    total=0.0
    do ii=0,dimlon-1
       total= total+var1_ssn_mean({lat | lat_array(ii)},{lon | lon_array(ii)})
    end do
    print(total)

    var_reference=fspan(0.0,0.0,39)
    do ii=0,dimlon-1
       ; plot@$unique_string("fxxk ncl")$    = gsn_add_polymarker(wks,plot,lon_array(ii),lat_array(ii),polyres)
       var_reference=var_reference+var_ssn({lat | lat_array(ii)},{lon | lon_array(ii)},time|:)*var1_ssn_mean({lat | lat_array(ii)},{lon | lon_array(ii)})/total
       ; print("lon="+lon_array(ii)+" lat="+lat_array(ii) +" proportion="+var1_ssn_mean({lat | lat_array(ii)},{lon | lon_array(ii)})/total )
    end do

    print("end counting var_reference")
    ;------end counting var reference-----
printVarSummary(var_reference)
print(var_reference)
r=var_ssn(0,:,:)
r=escorc(var_ssn(lat|:,lon|:,time|:),var_reference)
;print(r({lat | 0.0},{lon | 115.0}))


r_sig_level=0.316;  siglvl = 0.05
;  xtmp = pre_T_ssn(lat |:,lon |:,time |:)
;  ytmp = var_reference
;  aveX = dim_avg(xtmp)
;  aveY = dim_avg(ytmp)
;  varX = dim_variance(xtmp)
;  varY = dim_variance(ytmp)
;  eqvX = equiv_sample_size(xtmp,siglvl,0)
;  eqvY = equiv_sample_size(ytmp,siglvl,0)
;  nX   = wgt_areaave(eqvX, 1, 1, 0)
;  nY   = wgt_areaave(eqvY, 1, 1, 0)
;  prob = pre_T_ssn(0,:,:)
;  prob = ttest(aveX, varX, nX, aveY, varY, nY, False, False)
;  pre_diff_sig=var
;  pre_diff_sig=mask(var, prob .lt. siglvl, True)
  ;printVarSummary(var)
  ;printVarSummary(prob)
  ;printVarSummary(pre_diff_sig)
sig=var_ssn(0,:,:)
sig=mask(r, abs(r) .gt. r_sig_level,True)

wks = gsn_open_wks("png",outfile)
gsn_define_colormap(wks,"BlueWhiteOrangeRed")
res=True
res@gsnDraw         = False
res@gsnFrame        = False
res@gsnLeftString   = "Z_500hPa & multicenter correlation coefficient "                   
res@gsnRightString  = "NCEP_DOE"                 
res@gsnCenterString = " "
res@cnLineThicknessF =3.
res@cnLinesOn            = False
res@cnFillOn             = True
res@cnLevelSelectionMode = "ManualLevels"
res@cnFillColors =(/2,17,33,49,81,161,193,209,225,241/)
res@cnMinLevelValF        = -0.8         ; set min contour level
res@cnMaxLevelValF        = 0.8         ; set max contour level
res@cnLevelSpacingF       = 0.2          ; set contour interval
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
  overlay(plot1,plot2)
  draw(plot1)
  frame(wks)
end
