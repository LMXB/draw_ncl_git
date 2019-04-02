begin

case_name_list=(/"HEAT","HEAT_F","HEAT_NA","HEAT_TEST"/)
do i=0,3,1
case_name=case_name_list(i)
  g_font = 0.021
  l_thick= 3
  ;outfile="/home/ys17-19/cjx/figure/heat_test_figure/global_height_200_Rossby"
  outfile="/home/ys17-19/cjx/figure/"+case_name+"_figure/global_height_200_Rossby"
  ;HEAT_file="/home/ys17-19/cjx/all_output_data/HEAT_TEST_output_data/MAM_HEAT.cam.h0.1-30.nc"
  HEAT_file="/home/ys17-19/cjx/all_output_data/"+case_name+"_output_data/MAM_HEAT.cam.h0.1-30.nc"
  CTRL_file="/home/ys17-19/data-model/CESM_CTRL/F2000_F19_CAM4_CTRL/pro/CTRL.cam.h0.Z3.1-110.nc"
  fin_heat = addfile(HEAT_file,"r")
  fin_ctrl = addfile(CTRL_file,"r")
  pre_heat = fin_heat->Z3(120:359:1,{200},:,:)
  pre_ctrl = fin_ctrl->Z3(120:359:1,{200},:,:)
  pre_diff = pre_heat
  pre_diff = (pre_heat - pre_ctrl)
  pre_diff_ssn = month_to_season(pre_diff,"MAM")
      var  = dim_avg_n_Wrap(pre_diff_ssn,0)
  
  wks = gsn_open_wks("png",outfile)     
;  gsn_define_colormap(wks,"BlueWhiteOrangeRed")
   
  res                 = True 
  res@gsnDraw         = False
  res@gsnFrame        = False
  res@gsnContourZeroLineThicknessF = 0
  res@gsnLeftString   = " "                   
  res@gsnRightString  = " "                 
   res@gsnCenterString = " "
;  res@gsnCenterStringFontHeightF = 0.05  
  
  res@cnLevelSelectionMode  = "ManualLevels" ; set manual contour levels
 ; res@cnLevels      =(/-400, -300,-200,-100, 0, 100 ,400,800, 1200,1600,2000 /)
 ; res@cnFillColors =(/218, 202, 186, 170, 154, 122,  90, 74, 58, 42, 26, 10/)
 
 ; res@cnFillColors =(/10,26,42,58,74,90,106,122,138,154,170,186,202,218,234,250/)
  res@cnMinLevelValF        = -60         ; set min contour level
  res@cnMaxLevelValF        = 80         ; set max contour level
  res@cnLevelSpacingF       = 10          ; set contour interval
 ;   绘制的地图区域
  res@mpMinLatF    = -90          
  res@mpMaxLatF    = 10
;  res@mpMinLonF    = 30
;  res@mpMaxLonF    = 130
  
  res@mpFillOn               = False         
  res@cnFillOn      = False                  
  res@cnLinesOn     = True                 
 

  res@tmXBLabelFontHeightF =g_font 
  res@tmYLLabelFontHeightF =g_font
  res@tmXBTickSpacingF = 60
  res@tmYLTickSpacingF = 30
  res@cnLineLabelsOn   =False
  res@lbLabelFontHeightF = g_font
  res@cnLineThicknessF =l_thick
  res@cnInfoLabelOn =False
  plot = gsn_csm_contour_map(wks,var,res)
  plot = ColorNegDashZeroPosContour(plot,"black","black","red")

  draw(plot)
  frame(wks)
end do
end
