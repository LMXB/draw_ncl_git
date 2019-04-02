l_thick= 2
g_font = 0.025
begin
outfile="/home/ys17-19/cjx/figure/correlation-observation/regression_uwnd200"
u_file="/home/yangsong3/data-observation/NCEP_DOE/monthly/197901-201801/uwnd.mon.mean.nc"
v_file="/home/yangsong3/data-observation/NCEP_DOE/monthly/197901-201801/vwnd.mon.mean.nc"
fin_u = addfile(u_file,"r")
fin_v = addfile(v_file,"r")

uwnd = fin_u->uwnd(0:467:1,{200},:,:)
;printVarSummary(uwnd)
uwnd_ssn = month_to_season(short2flt(uwnd),"MAM")
;printVarSummary(uwnd_ssn)
uwnd_reference=uwnd_ssn({lat | 0.0},{lon | 115.0},time|:)
;printVarSummary(uwnd_reference)
;;print(uwnd_reference)
rc_uwnd=uwnd_ssn(0,:,:)
rc_uwnd=(/regCoef_n(uwnd_reference,uwnd_ssn,0,0)/)
;printVarSummary(rc_uwnd)
;;print(rc_uwnd)
;print(rc_uwnd({lat | 0.0},{lon | 115.0}))

vwnd = fin_v->vwnd(0:467:1,{200},:,:)
;printVarSummary(vwnd)
vwnd_ssn = month_to_season(short2flt(vwnd),"MAM")
;printVarSummary(vwnd_ssn)
vwnd_reference=vwnd_ssn({lat | 0.0},{lon | 115.0},time|:)
;printVarSummary(vwnd_reference)
;;print(vwnd_reference)
rc_vwnd=vwnd_ssn(0,:,:)
rc_vwnd=(/regCoef_n(vwnd_reference,vwnd_ssn,0,0)/)
;printVarSummary(rc_vwnd)
;;print(rc_vwnd)
;print(rc_vwnd({lat | 0.0},{lon | 115.0}))

r_sig_level=0.316;  siglvl = 0.05
sig=uwnd_ssn(0,:,:)
sig=mask(rc_uwnd, rc_uwnd .gt. r_sig_level .and. rc_vwnd .gt. r_sig_level, True)

  wks = gsn_open_wks("x11",outfile)     
  gsn_define_colormap(wks,"BlueWhiteOrangeRed")
   
  res                 = True  
  res@gsnDraw         = False
  res@gsnFrame        = False
  res@lbLabelFontHeightF = g_font
  res@tmXBLabelFontHeightF = g_font
  res@tmYLLabelFontHeightF = g_font
  res@tmXBTickSpacingF =60
  res@tmYLTickSpacingF =30
  ;res@cnLineLabelsOn   = False      ; turn off contour line labels
  res@gsnMaximize      = True       ; fill up the page
  res@gsnLeftString   = " "                   
  res@gsnRightString  = " "                 
  res@gsnCenterString = " "
;  res@gsnCenterStringFontHeightF = g_font  
   res@mpFillOn               = False
   res@mpCenterLonF           =180
   res@mpGeophysicalLineThicknessF = l_thick
   res@mpGridLineThicknessF   = l_thick
   res@vcGlyphStyle         = "FillArrow" ;  "CurlyVector" , "WindBarb"   
;  res@mpGridSpacingF         = 10.     ;
  ;res@pmTickMarkDisplayMode = "Always"
  ;; 箭头头部大小一致。若要绘制头部大小不一致箭头可参考第4章示例。
  res@vcFillArrowMinFracWidthF = 0.5 
  res@vcFillArrowHeadMinFracXF = 0.5  
  res@vcFillArrowHeadMinFracYF = 0.5 
  ;; 参考箭头
  res@vcRefAnnoOn               = True  
  res@vcRefMagnitudeF           = 0.5      ;标准长度箭头所表示的大小
  res@vcRefLengthF              = 0.02  ;标准长度箭头在图形中的长度
  res@vcRefAnnoBackgroundColor  = "white" ;背景颜色     
  res@vcRefAnnoPerimOn          = False   ;关闭边框   
  res@vcRefAnnoFontHeightF      = 0.015   ;参考箭头标签字体大小      
  res@vcRefAnnoString1On        = False   ;设定参考箭头上、        
  res@vcRefAnnoString2On        = True    ;        下的字符
  res@vcRefAnnoString2          = "0.5 m/s"  
  res@vcMinDistanceF            = 0.02
  res@vcRefAnnoOrthogonalPosF   = 0.154

  res4                  = True       ; use plot options
  res4@cnFillOn         = True       ; Fill contours
  res4@cnLinesOn        = False;True      ; turn off contour lines
  res4@gsnFrame         = False
  res4@gsnDraw  = False
  res4@gsnLeftString   = " "                   
  res4@gsnRightString  = " "                 
  res4@gsnCenterString = " "
  res4@cnLineThicknessF = 2
  res4@cnLineColor      = "black"
  res4@cnInfoLabelOn = False
;  res4@cnMonoFillPattern    = True
;  res4@cnFillPattern = 17
;  res4@cnMonoFillScale = True
;  res4@cnFillScaleF = 1.
;  res4@cnMonoFillColor = True
;  res4@cnFillDotSizeF = 0.004
  res4@cnFillOn     = True
  ;res4@cnLevelSelectionMode ="ExplicitLevels"
  ;res4@cnLevels     = (/0,1/)
  ;res4@cnFillColor  = (/229,229,229/)
  res4@cnFillColor  = "red"
  res4@cnFillOpacityF=0.5
  res4@lbLabelBarOn     = False
  

  plot1 = gsn_csm_vector_map(wks,rc_uwnd,rc_vwnd,res)
  plot2 = gsn_csm_contour(wks,sig,res4)
;  plot  = gsn_csm_vector_map_polar(wks,u,v,res)
  overlay(plot1,plot2)
  draw(plot1)
  frame(wks)
end
