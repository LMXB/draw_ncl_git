begin

l_thick = 2
g_font = 0.025
FillValue = 0.0
res=True
res@gsnDraw         = False
res@gsnFrame        = False
res@gsnLeftString   = " "                   
res@gsnRightString  = " "                 
res@cnLineThicknessF =3.
res@cnLinesOn            = False
res@cnFillOn             = True
res@cnLevelSelectionMode = "ManualLevels"
res@cnFillColors =(/2,17,33,49,113,129,177,193,209,225,241/)
res@cnMinLevelValF        = -0.08         ; set min contour level
res@cnMaxLevelValF        =  0.08         ; set max contour level
res@cnLevelSpacingF       =  0.02          ; set contour interval
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
;res@txString ="significant level(k) = 0.05"
;res@txPosXF=0.5
;res@txPosYF =0.5

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

polyres                   = True
polyres@gsMarkerIndex     = 2          ; polymarker style
polyres@gsMarkerSizeF     = 16.          ; polymarker size
polyres@gsMarkerThicknessF     = 6.          ; polymarker size
polyres@gsMarkerColor     = "green"          ; polymarker size

plot1 = new(1,"graphic")
plot2 = new(1,"graphic")

lon_array = (/10.0, 115.0, 140.0, 155.0, 231.0,  284.0, 310.0/)
lat_array = (/0.0,  0.0,   -5.0,  5.0,   5.0,    0.0,   0.0/)
range = 5.
level = (/200, 500, 850/)
siglvl = 0.01
var_name = (/"hgt", "air"/)

do i = 1, 1, 1
    in_olr="/home/ys17-19/cjx/all_output_data/PCOR/smooth_daily/olr_MAM_1979_2016.nc"
    fin_var1 = addfile(in_olr,"r")
    olr_in = fin_var1->olr_smooth(:,:,:)
    pre_olr =olr_in(time|:,{lat | lat_array(i)-range:lat_array(i)+range},{lon | lon_array(i)-range:lon_array(i)+range})
    olr = wgt_areaave(pre_olr,1.0,1.0,0)
    printVarSummary(olr)

    do j = 1, 1, 1
        in_file="/home/ys17-19/cjx/all_output_data/PCOR/smooth_daily/"+var_name(j)+"_MAM_1979_2016.nc"
        fin_var = addfile(in_file,"r")
        do k = 0, 2, 1
            var = fin_var->var_smooth(:,{level(k)},:,:)
            printVarSummary(var)
            outfile="/home/ys17-19/cjx/figure/regression-observation/olr_" + var_name(j) + "_" + level(k)

            rc_var=(/regCoef_n(olr,var,0,0)/)
            copy_VarCoords(var(0,:,:),rc_var)
            ;df_var = rc_var@nptxy-2
            ;tval_var = rc_var@tval
            ;prob_var_temp = student_t(tval_var,df_var)
            ;rc_var@FillValue = FillValue
            ;prob_var = onedtond(prob_var_temp, (/121, 240/)) 
            ;copy_VarCoords(var(0,:,:),prob_var)

            ;var_sig=var(0,:,:)
            ;var_sig=where(prob_var .le. siglvl, rc_var, rc_var@FillValue)
            ;printMinMax(var_sig, 0)

            wks = gsn_open_wks("png",outfile)
            res@gsnCenterString = "olr & "+var_name(j)+level(k)+" Regression Coefficient"
            gsn_define_colormap(wks,"BlueWhiteOrangeRed")
            plot1 = gsn_csm_contour_map(wks,rc_var,res)
            ;plot2 = gsn_csm_contour(wks,var_sig,res4)
            plot1@$unique_string("fxxk ncl")$    = gsn_add_polymarker(wks,plot1,lon_array(i),lat_array(i),polyres)
            ;overlay(plot1,plot2)
            draw(plot1)
            frame(wks)
        end do
    end do
end do
;delete(r)
;delete(prob)
;delete(sig)
;delete(res)
;delete(res4)
end
