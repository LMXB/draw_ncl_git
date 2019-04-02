    
    latS_TS   =  -90
    latN_TS   =  -50
    lonL_TS   =   180
    lonR_TS   =  360
    
     latS_FLUT   =  -10
     latN_FLUT   =  10
     lonL_FLUT   =  115
     lonR_FLUT   =  125

    yrStrt = 1
    yrLast = 30
    season  = "MAM"
    years = ispan(yrStrt,yrLast,1)
    nyears  = dimsizes(years)
    ;print(nyears)

;================================================
;Variables List:
;   var1--------------TS
;   var2--------------FLUT
;================================================

;initial data
TS_in = addfile("/home/ys17-19/cjx/all_output_data/HEAT_F_output_data/MAM_HEAT.cam.h0.1-30.T.nc", "r")
;time_TS = TS_in->time
;XXXX = cd_calendar(time_TS,-1 )
;t_index_start1 = ind(XXXX.eq.197401)
;t_index_end1   = ind(XXXX.eq.201612)
;TS = TS_in->TS(t_index_start1:t_index_end1,:,:)
TS = TS_in->T(:,{500},:,:)
TS_sp = month_to_season(TS, "MAM")

TS_spring= dim_standardize_n(TS_sp, 0, 0)
copy_VarCoords(TS_sp, TS_spring)
;printVarSummary(TS)
delete(TS)
TS = dim_standardize_n(TS_spring, 0, 0)
copy_VarCoords(TS_spring, TS)

FLUT_in = addfile("/home/ys17-19/cjx/all_output_data/HEAT_F_output_data/MAM_HEAT.cam.h0.1-30.FLUT.nc", "r")
;time_FLUT = FLUT_in->time
;XXXX = cd_calendar(time_FLUT,-1 )
;t_index_start1 = ind(XXXX.eq.197401)
;t_index_end1   = ind(XXXX.eq.201612)
;FLUT = FLUT_in->FLUT(t_index_start1:t_index_end1,:,:)
FLUT = FLUT_in->FLUT(:,:,:)
FLUT_sp = month_to_season(FLUT, "MAM")

FLUT_spring= dim_standardize_n(FLUT_sp, 0, 0)
copy_VarCoords(FLUT_sp, FLUT_spring)
;printVarSummary(FLUT)
delete(FLUT)
FLUT = dim_standardize_n(FLUT_spring, 0, 0)
copy_VarCoords(FLUT_spring, FLUT)

;------------------------not use----------------
;;FLUT_in = addfile("/home/ys17-19/cjx/all_output_data/HEAT_F_output_data/MAM_HEAT.cam.h0.1-30.FLUX.nc", "r")
;;FLUT1 = FLUT_in->FLUT
;;FLUT  = short2flt(FLUT1)
;;;printVarSummary(FLUT)
;;
;;FLUT_0 = dim_avg_n_Wrap(FLUT(:,:,:), 0)
;;;printVarSummary(FLUT_0)
;;
;;;time_FLUT = FLUT_in->time
;;;XXXX1 = cd_calendar(time_FLUT,-1 )
;;;  t_index_start11 = ind(XXXX1.eq.197501)
;;;  t_index_end11   = ind(XXXX1.eq.201612)
;;FLUT_2 = FLUT_in->FLUT(:,:,:)
;;FLUT_22= short2flt(FLUT_2)
;;;printVarSummary(FLUT_22)
;;FLUT_2_sp = month_to_season(FLUT_22, "JJA")
;;;printVarSummary(FLUT_2_sp)
;;
;;FLUT_sp = new((/43,73,144/),float)
;;FLUT_sp(0,:,:) = FLUT_0(:,:)
;;FLUT_sp(1:3,:,:) = FLUT_2_sp(0:2,:,:)
;;FLUT_sp(4,:,:) = dim_avg_n_Wrap(FLUT_2_sp, 0)
;;FLUT_sp(5:42,:,:) = FLUT_2_sp(4:41,:,:)
;;copy_VarCoords(FLUT_0,FLUT_sp(0,:,:))
;;FLUT_sp!0 = "time"
;;;printVarSummary(FLUT_sp)
;;
;;delete(FLUT)
;;FLUT = dim_standardize_n(FLUT_sp, 0, 0)
;;copy_VarCoords(FLUT_sp, FLUT)
;-------------------------------not use-------------------

;printVarSummary(TS)
;printVarSummary(FLUT)
;print("finish the first part")

    nmca = 2 ; how many MCA we need
    var1_region = TS(:,{latS_TS:latN_TS},{lonL_TS:lonR_TS});把TS数据reshape成二维
    var1_size = dimsizes(var1_region)
    n_var1_size = var1_size(1)*var1_size(2)
    homlft = new((/nmca,n_var1_size/),float)
    hetlft = new((/nmca,n_var1_size/),float)
    var1_ano_line = reshape(var1_region,(/var1_size(0),n_var1_size/))
    var1_ano_line!0 = "time" 
    var1_ano_line!1 = "pts"
    ;printVarSummary(var1_ano_line)
    ;printMinMax(var1_ano_line, False)

    var2_region = FLUT(:,{latS_FLUT:latN_FLUT},{lonL_FLUT:lonR_FLUT});把FLUT数据reshape成二维
    var2_size = dimsizes(var2_region)
    n_var2_size = var2_size(1)*var2_size(2)
    homrgt = new((/nmca,n_var2_size/),float)
    hetrgt = new((/nmca,n_var2_size/),float)
    var2_ano_line = reshape(var2_region,(/var2_size(0),n_var2_size/))
    var2_ano_line!0 = "time" 
    var2_ano_line!1 = "pts" 
    ;printVarSummary(var2_ano_line)
    ;printMinMax(var2_ano_line, False)

    ;print("finish the second part")
  ntime   = nyears                             ; # time steps
  ncols   = n_var1_size                        ; # columns (stations or grid pts) for S
  ncolz   = var2_size                          ; # columns (stations or grid pts) for Z
  nsvd    = 2                                  ; # svd patterns to calculate 
                                               ;   [nsvd <= min(ncols, ncolz) ]
  ; xmsg    = -999.9                             ; missing value
;  ;print(var1_ano_line(pts|:,time|:))
  x = svdcov(var1_ano_line(pts|:,time|:),var2_ano_line(pts|:,time|:),nsvd,homlft,hetlft,homrgt,hetrgt) 
  print("svdcov: percent variance= " + x)
  printVarSummary(x)

  ak   = onedtond(x@ak,(/nsvd,ntime/))
  bk   = onedtond(x@bk,(/nsvd,ntime/))
  ak!0 = "sv"
  ak!1 = "time"
  bk!0 = "sv"
  bk!1 = "time"

  ccr = escorc(ak(0,:), bk(0,:))
;  ;print(ccr)
;
;  ;print(ak)
;  ;print(bk)

    ak_std = dim_standardize_Wrap(ak,1)
    bk_std = dim_standardize_Wrap(bk,1)
    ;;printVarSummary(ak_std)
    ;;printVarSummary(bk_std)

    data = new((/2,nyears/),"float")
    data(0,:) = ak_std(0,:)
    data(1,:) = bk_std(0,:)

  ccr_ak = escorc_n(ak(0,:), FLUT, 0, 0)*-1
  copy_VarCoords(FLUT(0,:,:), ccr_ak)
  ;printVarSummary(ccr_ak)

  ccr_bk = escorc_n(bk(0,:), TS, 0, 0)*-1
  copy_VarCoords(TS(0,:,:), ccr_bk)
  ccr_bk@_FillValue = 9.96921e+36 
  ;printVarSummary(ccr_bk)


  test_ak = rtest(ccr_ak, nyears, 0)
  ; test_ak = where(ccr_ak.eq.ccr_ak@_FillValue, test_ak@_FillValue, test_ak)
  copy_VarCoords(ccr_ak, test_ak)

  ; test_bk = new((/180,360/),float)
  ; test_bk = sqrt(nyears-2)*ccr_bk/sqrt(1-ccr_bk*ccr_bk)
  ; test_bk=(/student_t(test_bk, nyears-2/)
  test_bk = rtest(ccr_bk, nyears, 0)
  test_bk = where(ccr_bk.eq.ccr_bk@_FillValue, test_bk@_FillValue, test_bk)
  copy_VarCoords(ccr_bk, test_bk)
  test_bk_reverse = 1 - test_bk
  copy_VarCoords(test_bk, test_bk_reverse)

  ;printVarSummary(test_ak)
  ;printMinMax(test_ak, False)
  ;printVarSummary(test_bk)
  ;printMinMax(test_bk, False)

  ; ==============================================================
; Set the figure parameters
; ==============================================================

    plot = new(2,"graphic")     ;shading
    plot_prob = new(2,"graphic")     ;shading
    wks_1  = gsn_open_wks("png","FLUT&TS_kongjian1")
    gsn_define_colormap(wks_1,"BlueWhiteOrangeRed")

    res                             = True
    ;res@cnFillDrawOrder             = "PreDraw"
    res@gsnDraw                     = False
    res@gsnFrame                    = False      ;don't advance frame
    res@gsnAddCyclic                = False      ;EOF data is not cyclic
    res@cnFillOn                    = True         ; turn on color fill
    res@cnLinesOn                   = False
    res@cnLineLabelsOn              = False      ;turn off cn line labels
    res@cnInfoLabelOn               = False      ;turn off contour information label
    res@mpFillOn                    = True        ; turn off map fill
    res@mpMinLatF                   = latS_FLUT
    res@mpMaxLatF                   = latN_FLUT
    res@mpMinLonF                   = lonL_FLUT
    res@mpMaxLonF                   = lonR_FLUT
    res@mpCenterLonF                = (lonL_FLUT+lonR_FLUT)/2
    
    res@lbLabelBarOn        = False
    ;res@lbOrientation       = "Horizonal"
    ;res@pmLabelBarParallelPosF="0.9"
    res@pmLabelBarHeightF   = 0.08
    res@pmLabelBarWidthF    = 0.55
    res@lbLabelFontHeightF  = 0.018
    res@pmLabelBarOrthogonalPosF    = 0.9

    res@tmXBLabelFontHeightF        = 0.022    ;font height of tick labels
    res@tmYLLabelFontHeightF        = 0.022
    res@tmXBTickSpacingF            = 10.     ;label spacing
    res@tmYLTickSpacingF            = 10.    ;label spacing

    res@gsnLeftStringFontHeightF    = 0.022
    res@gsnRightStringFontHeightF   = 0.022
    res@gsnLeftString               = " "
    res@gsnRightString              = " "
    res@cnLevelSelectionMode = "ManualLevels"
    res@cnMinLevelValF = -1
    res@cnMaxLevelValF = 1
    res@cnLevelSpacingF = 0.1
    res@pmLabelBarOrthogonalPosF    = 0.0
    plot(0) = gsn_csm_contour_map(wks_1,ccr_bk,res)

    wks_2  = gsn_open_wks("png","FLUT&TS_kongjian2")
    gsn_define_colormap(wks_2,"BlueWhiteOrangeRed")
    res@pmLabelBarOrthogonalPosF    = 0.5
    res@lbLabelBarOn        = True
    res@lbOrientation       = "Vertical"
    res@pmLabelBarHeightF   = 0.08
    res@tmYLTickSpacingF    = 30.
    res@tmXBTickSpacingF    = 60.     ;label spacing
    res@pmLabelBarOrthogonalPosF    = 0.5
    res@mpMinLatF           = latS_TS
    res@mpMaxLatF           = latN_TS
    res@mpMinLonF           = lonL_TS
    res@mpMaxLonF           = lonR_TS
    res@mpCenterLonF        = (lonL_TS+lonR_TS)/2

    res@cnLevelSelectionMode = "ManualLevels"
    res@cnMinLevelValF = -1
    res@cnMaxLevelValF = 1
    res@cnLevelSpacingF = 0.1

    plot(1) = gsn_csm_contour_map(wks_2,ccr_ak,res) ; create a default plot
  
  ;  wks_3  = gsn_open_wks("png","FLUT&TS_kongjian3")
  ;  gsn_define_colormap(wks_3,"BlueWhiteOrangeRed")
    res2 = True
    res2@gsnDraw = False
    res2@gsnFrame = False
    res2@gsnAddCyclic                = False      ;EOF data is not cyclic
    res2@cnFillOn                    = True         ; turn on color fill
    res2@cnLinesOn                   = False
    res2@cnLineLabelsOn              = False      ;turn off cn line labels
    res2@cnInfoLabelOn               = False      ;turn off contour information label
    res2@cnFillOn = True
    res2@cnLinesOn = False
    res2@cnLineLabelsOn = False
    res2@cnInfoLabelOn = False
    res2@lbLabelBarOn = False
    res2@cnMonoFillPattern = False
    res2@cnLevelSelectionMode = "ExplicitLevels"
    res2@cnLevels = (/0.1/)                       ;; set to significance level
    res2@cnFillPatterns = (/17,-1/)
    res2@cnFillColors = (/1,0/)
    res2@cnFillDotSizeF = 0.003
    res2@tmXBTickSpacingF =60
    res2@gsnLeftString = ""
    res2@gsnAddCyclic  = True

  plot_prob(0) = gsn_csm_contour(wks_1, test_bk, res2)
;    wks_4  = gsn_open_wks("png","FLUT&TS_kongjian4")
;    gsn_define_colormap(wks_4,"BlueWhiteOrangeRed")
  plot_prob(1) = gsn_csm_contour(wks_2, test_ak, res2)

do i = 0, 1
    overlay(plot(i), plot_prob(i))
    draw(plot(i))
end do

;************************************************
; panel plot only resources
;************************************************
;resP = True
;resP@gsnPanelLabelBar = True
;; resP@lbOrientation = "Vertical"
;resP@gsnPanelMainString = "MAM IO TS&FLUT SVD" 
;gsn_panel(wks,plot,(/2,1/),resP)     ; now draw as one plot
;************************************************
    wks_ts  = gsn_open_wks("png","FLUT&TS_shijian")

    rts           = True
    rts@gsnDraw   = False       ; don't draw yet
    rts@gsnFrame  = False       ; don't advance frame yet
    rts@vpXF     = 0.15
    rts@vpWidthF = 0.8
    rts@vpHeightF= 0.35
    rts@tiYAxisString = "Standardized"         ; y-axis label
;   rts@tiYAxisString = " "                    ; y-axis label
    rts@tmXBLabelFontHeightF = 0.02    ;font height of tick labels
    rts@tmYLLabelFontHeightF = 0.02    
    rts@gsnLeftStringFontHeightF = 0.02
    rts@gsnRightStringFontHeightF = 0.02

    rts@gsnYRefLine        = 0.              ; reference line   
    rts@xyLineColors       = (/"blue","red"/) ; colors chosen
    rts@xyLineThicknesses  = (/3.0,3.0/)      ; line thicknesses
    rts@xyDashPatterns     = (/0.,0./)      ; make all lines solid

    rts@trXMinF          = yrStrt  ; leave a margin for legend
    rts@trXMaxF          = yrLast
    ;rts@tmXBMode         = "Manual" ; Define own tick mark labels.
    rts@tmXBTickSpacingF = 5

    rts@trYMinF      = -3.0            ; min value on x-axis
    rts@trYMaxF      = 3.0            ; max value on x-axis
    
    rts@gsnLeftString = "Time Series of SVD1 (R = "+sprintf("%5.2f",ccr)+")" 
    rts@gsnRightString = sprintf("%5.2f",x(0))+"%"
    plot_ts = gsn_xy(wks_ts,years,data*-1,rts)
    print("Time Series of SVD1 (R = "+sprintf("%5.2f",ccr)+")")

;---------------------------Add plot legend-----------------------------------
    res_lines                   = True                  ; polyline mods desired
    res_lines@gsLineDashPattern = 0.                    ; solid line
    res_lines@gsLineThicknessF  = 3.                    ; line thicker
    
    res_text                    = True                  ; text mods desired
    res_text@txFontHeightF      = 0.015                 ; change text size
    res_text@txJust             = "CenterLeft"          ; text justification

    res_lines@gsLineColor       = "blue"
    yy = (/2.5,2.5/)
    xx = (/2007,2010/)
    text_pos = 2011
    dum11 = gsn_add_polyline(wks_ts,plot_ts,xx,yy,res_lines)              ; add polyline
    dum12 = gsn_add_text(wks_ts,plot_ts,"SST",text_pos,yy(0),res_text); add text

    res_lines@gsLineColor       = "red"
    yy = yy - 0.6
    dum21 = gsn_add_polyline(wks_ts,plot_ts,xx,yy,res_lines)              ; add polyline
    dum22 = gsn_add_text(wks_ts,plot_ts,"OLR",text_pos,yy(0),res_text); add text

    draw(plot_ts)

    frame(wks_1)
    frame(wks_2)
    ;frame(wks_3)
    ;frame(wks_4)
    frame(wks_ts)
