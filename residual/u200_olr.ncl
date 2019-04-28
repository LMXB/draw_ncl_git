l_thick= 2
g_font = 0.025
begin
;lon_array=(/10.0, 115.0, 140.0, 155.0, 231.0,  284.0, 310.0/)
;lat_array=(/0.0,  0.0,   -5.0,  5.0,   5.0,    0.0,   0.0/)
;do i=0,6,1
g_strt_mon = 197901
g_lst_mon = 201812
range=6
outfile="/home/ys17-19/cjx/figure/residual/olr_u200"

;------------------------input data---------------
in_file1="/home/ys17-19/cjx/observation_data/olr.mon.mean.nc"
fin_var1 = addfile(in_file1,"r")
time_olr = fin_var1->time
yyyymm_olr  = cd_calendar(time_olr,-1)
istrt_olr   = ind(yyyymm_olr .eq. g_strt_mon)
ilast_olr   = ind(yyyymm_olr .eq. g_lst_mon)
var1 = fin_var1->olr(istrt_olr:ilast_olr,:,:)
;in_file1="/home/ys17-19/cjx/observation_data/gpcp_v02r03_monthly_197901_201901.nc"
;fin_var1 = addfile(in_file1,"r")
;var1 = fin_var1->precip(0:479:1,:,:)
olr_in  =short2flt(var1)			; p for unify the var name


in_file2="/home/ys17-19/cjx/observation_data/ERA-Interim/era_interim_uv.nc"
fin_var2 = addfile(in_file2,"r")
time_var = fin_var2->time
yyyymm_var  = cd_calendar(time_var,-1)
istrt_var   = ind(yyyymm_var .eq. g_strt_mon)
ilast_var   = ind(yyyymm_var .eq. g_lst_mon)
var2 = fin_var2->u(istrt_var:ilast_var,{200},:,:)
printVarSummary(var2)
var2_ssn = month_to_season(short2flt(var2),"MAM")
printVarSummary(var2_ssn)


in_file3="/home/ys17-19/cjx/draw_ncl_git/PCOR/nino3.nc"
fin_var3=addfile(in_file3,"r")
nino3=fin_var3->nino3

;-----------------count the region average olr in MC----
pre_olr =olr_in(time|:,{lat | 0-range:0+range},{lon | 115-range:115+range})
;pre_olr =olr_in(time|:,{latitude | 0-range:0+range},{longitude | 115-range:115+range})  ;precip
pre_olr_ssn = month_to_season(pre_olr,"MAM")
printVarSummary(pre_olr_ssn)
var1_reference = wgt_areaave(pre_olr_ssn,1.0,1.0,0)
printVarSummary(var1_reference)

;------------count the residual error-------
r_tmp=regCoef_n(nino3,var2_ssn,0,0)
copy_VarCoords(var2_ssn(0,:,:), r_tmp)
printVarSummary(r_tmp)
r_in=conform(var2_ssn,r_tmp,(/1,2/))

yint_tmp=r_tmp@yintercept
yint=onedtond(yint_tmp,(/241,480/))
copy_VarCoords(var2_ssn(0,:,:), yint)
printVarSummary(yint)
yint_in=conform(var2_ssn,yint,(/1,2/))

x=conform(var2_ssn,nino3,0)
copy_VarCoords(var2_ssn, x)
printVarSummary(x)

err=var2_ssn
var2_ssn_Ref=var2_ssn

var2_ssn_Ref=r_in*x+yint_in
err=var2_ssn-var2_ssn_Ref
printVarSummary(var2_ssn_Ref)
printVarSummary(err)

;------------count the correlation coefficients----
r=var2_ssn(0,:,:)
r=escorc(var1_reference,err(latitude|:,longitude|:,time|:))
;print(r)


;--------------significant r test--------
siglvl = 0.05
prob=rtest(r,num(var2_ssn(:,0,0)),0)
sig=var2_ssn(0,:,:)
sig=mask(r, prob .lt.siglvl, True)


;---------------draw the figure-------------
wks = gsn_open_wks("png",outfile)
gsn_define_colormap(wks,"BlueWhiteOrangeRed")
res=True
res@gsnDraw         = False
res@gsnFrame        = False
res@gsnLeftString   = " "                   
res@gsnRightString  = " "                 
res@gsnCenterString = "olr & u200 residual regression coefficient"
;res@gsnCenterString = ""
res@cnLineThicknessF =3.
res@cnLinesOn            = False
res@cnFillOn             = True
res@cnLevelSelectionMode = "ManualLevels"
res@cnFillColors =(/2,17,33,49,97,145,193,209,225,241/)
res@cnMinLevelValF        = -0.8         ; set min contour level
res@cnMaxLevelValF        = 0.8         ; set max contour level
res@cnLevelSpacingF       = 0.2          ; set contour interval
res@mpFillOn=False
res@mpCenterLonF =180
;res@mpMaxLatF=lat_N
;res@mpMinLatF=lat_S
;res@mpMaxLonF=lon_W
;res@mpMinLonF=lon_E
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
  res4@cnLinesOn        = False;True      ; turn off contour lines
  res4@lbLabelBarOn     = False
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
  ;plot1 = gsn_csm_contour_map(wks,err(0,:,:),res)
  plot2 = gsn_csm_contour(wks,sig,res4)
  polyres                   = True
  polyres@gsMarkerIndex     = 2          ; polymarker style
  polyres@gsMarkerSizeF     = 16.          ; polymarker size
  polyres@gsMarkerThicknessF     = 6.          ; polymarker size
  polyres@gsMarkerColor     = "green"          ; polymarker size
  plot1@$unique_string("fxxk ncl")$    = gsn_add_polymarker(wks,plot1,115,0,polyres)
  overlay(plot1,plot2)
  draw(plot1)
  frame(wks)
;end do
delete(r)
delete(prob)
delete(sig)
delete(res)
delete(res4)
end
