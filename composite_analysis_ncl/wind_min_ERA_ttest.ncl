begin
  g_font = 0.025
  lat_N=70
  lat_S=-70
  lon_E=90
  lon_W=280
  l_thick= 2
  level=(/925,850,500,200/)
do i=0,3,1
  fils = "/home/ys17-19/cjx/observation_data/ERA-Interim/era_interim_uv.nc" 
  outfile="/home/ys17-19/cjx/figure/composite_analysis_figure/ERA_wind_ttest_"+level(i)+"_min"
  fin_ctrl = addfiles(fils,"r")
  U_in = short2flt(fin_ctrl[:]->u)
  U_ctrl = U_in(:,{level(i)},:,:)
;  U_ctrl = fin_ctrl->H(120:359:1,{500},:,:)
  U_ctrl_ssn = month_to_season(U_ctrl,"MAM")
  ;printVarSummary(U_ctrl_ssn)
  abnormal = (/2,4,8,12,14,18,36/)
  normal = (/0,1,3,5,6,7,9,10,11,13,15,16,17,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,37,38,39/)
  min_U=U_ctrl_ssn(abnormal,:,:)
  min_U_ssn  = dim_avg_n_Wrap(min_U,0)
  U  = dim_avg_n_Wrap(U_ctrl_ssn,0)
  U_diff = U
  U_diff = min_U_ssn-U 
  nor_U=U_ctrl_ssn(normal,:,:)

  ;ttest
  siglvl = 0.05
  xtmp = min_U(latitude |:,longitude |:,time |:)
  ytmp = nor_U(latitude |:,longitude |:,time |:)
  aveX = dim_avg(xtmp)
  aveY = dim_avg(ytmp)
  varX = dim_variance(xtmp)
  varY = dim_variance(ytmp)
  eqvX = equiv_sample_size(xtmp,siglvl,0)
  eqvY = equiv_sample_size(ytmp,siglvl,0)
  nX   = wgt_areaave(eqvX, 1, 1, 0)
  nY   = wgt_areaave(eqvY, 1, 1, 0)
  U_prob = U_ctrl(0,:,:)
  ;print(U_prob)
  U_prob = ttest(aveX, varX, nX, aveY, varY, nY, False, False)
  ;printVarSummary(U)
  ;printVarSummary(U_prob)
  ;printVarSummary(pre_diff_sig)

  V_in = short2flt(fin_ctrl[:]->v)
  V_ctrl = V_in(:,{level(i)},:,:)
;  V_ctrl = fin_ctrl->H(120:359:1,{500},:,:)
  V_ctrl_ssn = month_to_season(V_ctrl,"MAM")
  ;printVarSummary(V_ctrl_ssn)
  min_V=V_ctrl_ssn(abnormal,:,:)
  min_V_ssn  = dim_avg_n_Wrap(min_V,0)
  V  = dim_avg_n_Wrap(V_ctrl_ssn,0)
  V_diff = V
  V_diff = min_V_ssn-V 
  nor_V=V_ctrl_ssn(normal,:,:)

  ;ttest
  siglvl = 0.05
  xtmp = min_V(latitude |:,longitude |:,time |:)
  ytmp = nor_V(latitude |:,longitude |:,time |:)
  aveX = dim_avg(xtmp)
  aveY = dim_avg(ytmp)
  varX = dim_variance(xtmp)
  varY = dim_variance(ytmp)
  eqvX = equiv_sample_size(xtmp,siglvl,0)
  eqvY = equiv_sample_size(ytmp,siglvl,0)
  nX   = wgt_areaave(eqvX, 1, 1, 0)
  nY   = wgt_areaave(eqvY, 1, 1, 0)
  V_prob = V_ctrl(0,:,:)
  ;print(V_prob)
  V_prob = ttest(aveX, varX, nX, aveY, varY, nY, False, False)
  V_diff_sig=V
  V_diff_sig=mask(V_diff, V_prob .lt. siglvl .or. U_prob .lt. siglvl, True)
  U_diff_sig=U
  U_diff_sig=mask(U_diff, V_prob .lt. siglvl .or. U_prob .lt. siglvl, True)
  V_diff_usig=V
  V_diff_usig=mask(V_diff, V_prob .lt. siglvl .or. U_prob .lt. siglvl, False)
  U_diff_usig=U
  U_diff_usig=mask(U_diff, V_prob .lt. siglvl .or. U_prob .lt. siglvl, False)
  ;printVarSummary(V)
  ;printVarSummary(V_prob)
  ;printVarSummary(pre_diff_sig)


    plot1 = new(1,"graphic")
    plot2 = new(1,"graphic")
  wks = gsn_open_wks("png",outfile)     
  gsn_define_colormap(wks,"BlueWhiteOrangeRed")
  

  res                 = True  
  res@gsnDraw         = False
  res@gsnFrame        = False
  res@tmXBTickSpacingF =60
  res@tmYLTickSpacingF =30
  res@lbLabelFontHeightF = g_font
  res@mpCenterLonF = 180.
  ;res@cnLineLabelsOn   = False      ; turn off contour line labels
  res@gsnMaximize      = True       ; fill up the page
  res@gsnLeftString   = " "                   
  res@gsnRightString  = " "                 
  res@gsnCenterString = "min year Wind"+level(i)+" diff" 
;  res@gsnCenterStringFontHeightF = g_font  
   res@tiMainOn               = False
   res@mpFillOn               = False
   res@mpGeophysicalLineThicknessF = l_thick
   res@mpGridLineThicknessF   = l_thick
   res@tmXBLabelFontHeightF = g_font
   res@tmYLLabelFontHeightF = g_font
   res@vcGlyphStyle         = "FillArrow" ;  "CurlyVector" , "WindBarb"   
;  res@mpGridSpacingF         = 10.     ;
  ;res@pmTickMarkDisplayMode = "Always"
  ;; 箭头头部大小一致。若要绘制头部大小不一致箭头可参考第4章示例。

  res@vcFillArrowEdgeColor     = "grey"
  res@vcFillArrowFillColor     = "grey"
  res@vcGlyphOpacityF           =0.2
  res@vcFillArrowMinFracWidthF = 0.3 
  res@vcFillArrowHeadMinFracXF = 0.3  
  res@vcFillArrowHeadMinFracYF = 0.3 
  ;; 参考箭头
  res@vcRefAnnoOn               = True  
  res@vcRefMagnitudeF           = 2      ;标准长度箭头所表示的大小
  res@vcRefLengthF              = 0.05  ;标准长度箭头在图形中的长度
  res@vcRefAnnoBackgroundColor  = "white" ;背景颜色     
  res@vcRefAnnoPerimOn          = False   ;关闭边框   
  res@vcRefAnnoFontHeightF      = 0.014   ;参考箭头标签字体大小      
  res@vcRefAnnoString1On        = False   ;设定参考箭头上、        
  res@vcRefAnnoString2On        = True    ;        下的字符
  res@vcRefAnnoString2          = "2 m/s" 
  res@vcRefAnnoOrthogonalPosF   = 0.155
  res@vcRefAnnoArrowUseVecColor = False
  res@vcRefAnnoArrowEdgeColor   ="black"
  res@vcRefAnnoArrowFillColor   ="black"
  res@vcMinDistanceF            = 0.02
  res@mpMaxLatF=lat_N
  res@mpMinLatF=lat_S
  res@mpMaxLonF=lon_W
  res@mpMinLonF=lon_E

  res4                 = True  
  res4@gsnDraw         = False
  res4@gsnFrame        = False
  res4@lbLabelFontHeightF = g_font
  res4@gsnMaximize      = True       ; fill up the page
  res4@gsnLeftString   = " "                   
  res4@gsnRightString  = " "                 
  res4@gsnCenterString = " " 
  res4@tmYLLabelFontHeightF = g_font
  res4@vcGlyphStyle         = "FillArrow" ;  "CurlyVector" , "WindBarb"   
; res4@mpGridSpacingF         = 10.     ;
  ;re4s@pmTickMarkDisplayMode = "Always"
  ;; 4箭头头部大小一致。若要绘制头部大小不一致箭头可参考第4章示例。
  res4@vcFillArrowEdgeColor     = "black"
  res4@vcFillArrowFillColor     = "black"
  res4@vcFillArrowMinFracWidthF = 0.3 
  res4@vcFillArrowHeadMinFracXF = 0.3  
  res4@vcFillArrowHeadMinFracYF = 0.3 
  ;; 4参考箭头
  res4@vcRefAnnoOn               = True  
  res4@vcRefMagnitudeF           = 2      ;标准长度箭头所表示的大小
  res4@vcRefLengthF              = 0.05  ;标准长度箭头在图形中的长度
  res4@vcRefAnnoBackgroundColor  = "white" ;背景颜色     
  res4@vcRefAnnoPerimOn          = False   ;关闭边框   
  res4@vcRefAnnoFontHeightF      = 0.014   ;参考箭头标签字体大小      
  res4@vcRefAnnoString1On        = False   ;设定参考箭头上、        
  res4@vcRefAnnoString2On        = True    ;        下的字符
  res4@vcRefAnnoString2          = "2 m/s" 
  res4@vcRefAnnoOrthogonalPosF   = 0.155
  res4@vcMinDistanceF            = 0.02
  res4@vcRefAnnoArrowEdgeColor   ="black"
  res4@vcRefAnnoArrowFillColor   ="black"

  plot1 = gsn_csm_vector_map(wks,U_diff_usig,V_diff_usig,res)
  plot2 = gsn_csm_vector(wks,U_diff_sig,V_diff_sig,res4)
  ;plot  = gsn_csm_vector_map_polar(wks,u,v,res)
  polyres                   = True
  polyres@gsMarkerIndex     = 10          ; polymarker style
  polyres@gsMarkerSizeF     = 16.          ; polymarker size
  polyres@gsMarkerThicknessF     = 6.          ; polymarker size
  polyres@gsMarkerColor     = "green"          ; polymarker size
  plot1@$unique_string("fxxk ncl")$    = gsn_add_polymarker(wks,plot1,115,0,polyres)
  overlay(plot1,plot2)
  draw(plot1)
  frame(wks)
  end do
delete(res)
delete(res4)
delete(level)
;delete(case_name)
end
