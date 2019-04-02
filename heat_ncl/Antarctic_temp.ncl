begin
  outfile="/home/ys17-19/cjx/figure/heat_test_figure/Antarctic_temp"
  HEAT_file="/home/ys17-19/cjx/all_output_data/HEAT_TEST_output_data/MAM_HEAT.cam.h0.1-30.TS.nc"
  CTRL_file="/home/ys17-19/cjx/output_data/CTRL.cam.h0.1-65.TS.nc"
  fin_heat = addfile(HEAT_file,"r")
  fin_ctrl = addfile(CTRL_file,"r")
  pre_heat = fin_heat->TS(120:359:1,:,:)
  pre_ctrl = fin_ctrl->TS(120:359:1,:,:)
  pre_diff = pre_heat
  pre_diff = (pre_heat - pre_ctrl)
  pre_diff_ssn = month_to_season(pre_diff,"MAM")
      var  = dim_avg_n_Wrap(pre_diff_ssn,0)
  
  wks = gsn_open_wks("png",outfile)     
  gsn_define_colormap(wks,"temp_diff_18lev")
   
  res                 = True                   
  res@gsnLeftString   = "height_diff = heat-ctrl"                   
;  res@gsnRightString  = "m"                 
   res@gsnCenterString = "surface temperature"
;  res@gsnCenterStringFontHeightF = 0.05  
   res@gsnPolar              = "SH"
   res@mpMaxLatF            = -45  

  res@pmTickMarkDisplayMode = "Always"
  res@cnLevelSelectionMode  = "ManualLevels" ; set manual contour levels
;  res@cnLevels      =(/-400, -300,-200,-100, 0, 100 ,400,800, 1200,1600,2000 /)
  res@cnFillColors =(/2, 4, 6, 8, 10, 11, 11, 13, 15, 17, 19, 20/)
 
  res@cnMinLevelValF        = -2.0         ; set min contour level
  res@cnMaxLevelValF        = 2.0         ; set max contour level
  res@cnLevelSpacingF       = 0.4          ; set contour interval
 ;   绘制的地图区域
;  res@mpMinLatF    = 10          
;  res@mpMaxLatF    = 80
;  res@mpMinLonF    = 30
;  res@mpMaxLonF    = 130
  
  res@mpFillOn               = False         
;  res@mpGridSpacingF         = 10.     ;

  res@cnFillOn      = True                  
  res@cnLinesOn     = True                 
  
  plot = gsn_csm_contour_map_polar(wks,var,res)
end
