begin
l_thick= 2
g_font = 0.025
level=(/850,200/)
do j=0,1,1
outfile="/home/ys17-19/cjx/figure/regression-observation/lon="+lon_array(i)+"/regression_wind"+level(j)
u_file="/home/yangsong3/data-observation/NCEP_DOE/monthly/197901-201801/uwnd.mon.mean.nc"
v_file="/home/yangsong3/data-observation/NCEP_DOE/monthly/197901-201801/vwnd.mon.mean.nc"
fin_u = addfile(u_file,"r")
fin_v = addfile(v_file,"r")
uwnd = fin_u->uwnd(0:467:1,{level(j)},:,:)
;printVarSummary(uwnd)
uwnd_ssn = month_to_season(short2flt(uwnd),"MAM")
;printVarSummary(uwnd_ssn)
uwnd_reference=uwnd_ssn({lat | lat_array(i)},{lon | lon_array(i)},time|:)
;printVarSummary(uwnd_reference)
;;print(uwnd_reference)
rc_uwnd=uwnd_ssn(0,:,:)
rc_uwnd=(/regCoef_n(uwnd_reference,uwnd_ssn,0,0)/)
;printVarSummary(rc_uwnd)
;;print(rc_uwnd)
;print(rc_uwnd({lat | 0.0},{lon | 115.0}))

vwnd = fin_v->vwnd(0:467:1,{level(j)},:,:)
;printVarSummary(vwnd)
vwnd_ssn = month_to_season(short2flt(vwnd),"MAM")
;printVarSummary(vwnd_ssn)
vwnd_reference=vwnd_ssn({lat | lat_array(i)},{lon | lon_array(i)},time|:)
;printVarSummary(vwnd_reference)
;;print(vwnd_reference)
rc_vwnd=vwnd_ssn(0,:,:)
rc_vwnd=(/regCoef_n(vwnd_reference,vwnd_ssn,0,0)/)
printVarSummary(rc_vwnd)
;;print(rc_vwnd)
;print(rc_vwnd({lat | 0.0},{lon | 115.0}))


siglvl = 0.05
u_prob=rtest(rc_uwnd,num(uwnd_ssn(:,0,0)),0)
v_prob=rtest(rc_vwnd,num(vwnd_ssn(:,0,0)),0)
;print(u_nr)
;printVarSummary(u_prob)


sig_uwnd=uwnd_ssn(0,:,:)
sig_vwnd=vwnd_ssn(0,:,:)
sig_uwnd=mask(rc_uwnd, u_prob .lt.siglvl .or. v_prob .lt. siglvl, True)
sig_vwnd=mask(rc_vwnd, u_prob .lt.siglvl .or. v_prob .lt. siglvl, True)

usig_uwnd=uwnd_ssn(0,:,:)
usig_vwnd=vwnd_ssn(0,:,:)
usig_uwnd=mask(rc_uwnd, u_prob .lt.siglvl .or. v_prob .lt. siglvl, False)
usig_vwnd=mask(rc_vwnd, u_prob .lt.siglvl .or. v_prob .lt. siglvl, False)

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
  res@gsnCenterString = "wind"+level(j)+" regression coefficient"
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
  res@vcFillArrowMinFracWidthF = 0.3 
  res@vcFillArrowHeadMinFracXF = 0.3  
  res@vcFillArrowHeadMinFracYF = 0.3 
  ;; 参考箭头
  res@vcRefAnnoOn               = True  
  res@vcRefMagnitudeF           = 0.5      ;标准长度箭头所表示的大小
  res@vcRefLengthF              = 0.05  ;标准长度箭头在图形中的长度
  res@vcRefAnnoBackgroundColor  = "white" ;背景颜色     
  res@vcRefAnnoPerimOn          = False   ;关闭边框   
  res@vcRefAnnoFontHeightF      = 0.014   ;参考箭头标签字体大小      
  res@vcRefAnnoString1On        = False   ;设定参考箭头上、        
  res@vcRefAnnoString2On        = True    ;        下的字符
  res@vcRefAnnoString2          = "0.5 m/s" 
  res@vcRefAnnoOrthogonalPosF   = 0.155
  res@vcRefAnnoArrowUseVecColor = False
  res@vcRefAnnoArrowEdgeColor   ="black"
  res@vcRefAnnoArrowFillColor   ="black"
  res@vcGlyphOpacityF           =0.2
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

  plot1 = gsn_csm_vector_map(wks,usig_uwnd,usig_vwnd,res)
  plot2 = gsn_csm_vector(wks,sig_uwnd,sig_vwnd,res4)
;  plot  = gsn_csm_vector_map_polar(wks,u,v,res)
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
;delete(sig)
delete(res)
delete(res4)
delete(u_prob)
delete(v_prob)
end
