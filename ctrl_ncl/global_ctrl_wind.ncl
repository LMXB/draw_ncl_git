begin
  outfile="/home/ys17-19/cjx/figure/ctrl_figure/global_ctrl_wind_850"
  f_ctrl_U = addfile("/home/ys17-19/data-model/CESM_CTRL/F2000_F19_CAM4_CTRL/pro/CTRL.cam.h0.U.1-110.nc","r")
  f_ctrl_V = addfile("/home/ys17-19/cjx/output_data/CTRL.cam.h0.1-65.V.nc","r")

  u_ctrl = f_ctrl_U->U(120:359:1,{850},:,:)      
  v_ctrl = f_ctrl_V->V(120:359:1,{850},:,:)
 
  v_ctrl_ssn = month_to_season(v_ctrl,"MAM")
  u_ctrl_ssn = month_to_season(u_ctrl,"MAM")
  u = dim_avg_n_Wrap(u_ctrl_ssn,0)
  v = dim_avg_n_Wrap(v_ctrl_ssn,0)


  wks = gsn_open_wks("png",outfile) 

  res                      = True          ; Plot options desired.
  res@gsnLeftString        = ""
  res@gsnRightString       = ""
  res@tiMainString         = "wind_850hPa" 
  
  res@pmTickMarkDisplayMode = "Always" 
  
  res@vcGlyphStyle         = "FillArrow" ;  "CurlyVector" , "WindBarb"   

  ;; 箭头头部大小一致。若要绘制头部大小不一致箭头可参考第4章示例。
  res@vcFillArrowMinFracWidthF = 0.5 
  res@vcFillArrowHeadMinFracXF = 0.5  
  res@vcFillArrowHeadMinFracYF = 0.5 
  
  ;; 参考箭头
  res@vcRefAnnoOn               = True  
  res@vcRefMagnitudeF           = 5      ;标准长度箭头所表示的大小
  res@vcRefLengthF              = 0.02  ;标准长度箭头在图形中的长度
  res@vcRefAnnoBackgroundColor  = "white" ;背景颜色     
  res@vcRefAnnoPerimOn          = False   ;关闭边框   
  res@vcRefAnnoFontHeightF      = 0.015   ;参考箭头标签字体大小      
  res@vcRefAnnoString1On        = False   ;设定参考箭头上、        
  res@vcRefAnnoString2On        = True    ;        下的字符
  res@vcRefAnnoString2          = "5 m/s"  
  res@vcMinDistanceF            = 0.02

  plot  = gsn_csm_vector_map(wks,u,v,res)
end
