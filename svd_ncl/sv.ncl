    
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
printVarSummary(TS)
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

  ntime   = nyears                             ; # time steps
 ; ncols   = n_var1_size                        ; # columns (stations or grid pts) for S
 ; ncolz   = var2_size                          ; # columns (stations or grid pts) for Z
  nsvd    = 2                                  ; # svd patterns to calculate

    nmca = 2 ; how many MCA we need
    var1_region = TS(:,{latS_TS:latN_TS},{lonL_TS:lonR_TS});把TS数据reshape成二维
    var1_size = dimsizes(var1_region)
    n_var1_size = var1_size(1)*var1_size(2)
    svLeft = new((/nsvd,n_var1_size/),float)
    var1_ano_line = reshape(var1_region,(/var1_size(0),n_var1_size/))
    var1_ano_line!0 = "time" 
    var1_ano_line!1 = "pts"
    ;printVarSummary(var1_ano_line)
    ;printMinMax(var1_ano_line, False)

    var2_region = FLUT(:,{latS_FLUT:latN_FLUT},{lonL_FLUT:lonR_FLUT});把FLUT数据reshape成二维
    var2_size = dimsizes(var2_region)
    n_var2_size = var2_size(1)*var2_size(2)
    svRight = new((/nsvd,n_var2_size/),float)
    var2_ano_line = reshape(var2_region,(/var2_size(0),n_var2_size/))
    var2_ano_line!0 = "time" 
    var2_ano_line!1 = "pts" 
    ;printVarSummary(var2_ano_line)
    ;printMinMax(var2_ano_line, False)

    ;print("finish the second part")
                                               ;   [nsvd <= min(ncols, ncolz) ]
  ; xmsg    = -999.9                             ; missing value
;  ;print(var1_ano_line(pts|:,time|:))
  x = svdcov_sv(var1_ano_line(pts|:,time|:),var2_ano_line(pts|:,time|:),nsvd,svLeft,svRight) 
  print("svdcov: percent variance= " + x)
  printVarSummary(x)
  
  svLeft_1  = TS(0,{latS_TS:latN_TS},{lonL_TS:lonR_TS});把TS数据reshape成二维
  svLeft_1   = onedtond(svLeft(0,:),(/var1_size(1),var1_size(2)/))
  wks_1  = gsn_open_wks("png","SVD_Left_1")
  gsn_define_colormap(wks_1,"BlueWhiteOrangeRed")
  res=True 
  res@tmXBLabelFontHeightF        = 0.022    ;font height of tick labels
  res@pmLabelBarOrthogonalPosF    = 0.6
  res@tmXBTickSpacingF            = 60.     ;label spacing
  res@tmYLTickSpacingF            = 30.    ;label spacing
  res@tmYLLabelFontHeightF        = 0.022
  res@gsnAddCyclic                = False
  res@mpMinLatF           = latS_TS
  res@mpMaxLatF           = latN_TS
  res@mpMinLonF           = lonL_TS
  res@mpMaxLonF           = lonR_TS
  res@mpCenterLonF        = (lonL_TS+lonR_TS)/2
  res@cnFillOn                    = True         ; turn on color fill
  plot = gsn_csm_contour_map(wks_1,svLeft_1,res)

  svRight_1  = FLUT(0,{latS_FLUT:latN_FLUT},{lonL_FLUT:lonR_FLUT});把TS数据reshape成二维
  svRight_1   = onedtond(svRight(0,:),(/var2_size(1),var2_size(2)/))
  wks_2  = gsn_open_wks("png","SVD_Right_1")
  gsn_define_colormap(wks_2,"BlueWhiteOrangeRed")
  res=True
  res@gsnAddCyclic                = False
  res@mpMinLatF           = latS_FLUT
  res@mpMaxLatF           = latN_FLUT
  res@mpMinLonF           = lonL_FLUT
  res@mpMaxLonF           = lonR_FLUT
  res@mpCenterLonF        = (lonL_FLUT+lonR_FLUT)/2
  res@cnFillOn                    = True         ; turn on color fill
  plot = gsn_csm_contour_map(wks_2,svRight_1,res)
