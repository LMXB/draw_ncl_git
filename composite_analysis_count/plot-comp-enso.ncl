load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin
g_font = 0.025
l_thick= 2
level=(/200, 500, 850/)
year=ispan(1979,2013,1)  ; 79/80 - 13/14
it_s=197912  ;起始年月
it_e=201411  ;结束年月

resc                 = True  
resc@gsnDraw         = False
resc@gsnFrame        = False
resc@gsnMaximize      = True       ; fill up the page
resc@gsnLeftString   = ""                   
resc@gsnRightString  = ""                 
;resc@mpCenterLonF = 180.
;resc@mpFillOn               = False
;resc@mpGeophysicalLineThicknessF = l_thick
;resc@mpGridLineThicknessF   = l_thick
resc@cnFillOn      = True                  
resc@cnLinesOn     = False                 
resc@lbLabelFontHeightF = g_font
resc@tmYLMajorLengthF=0.01
resc@tmXBMajorLengthF=0.01
resc@tmXBLabelFontHeightF = g_font
resc@tmYLLabelFontHeightF = g_font
resc@tmXBTickSpacingF =60
resc@tmYLTickSpacingF =30
resc@gsnAddCyclic      = True   ; 添加循环点，否则会在0度经线左侧出现一根白条
resc@pmLabelBarOrthogonalPosF = 0.13
rest = resc
resc@cnLevelSelectionMode  = "ManualLevels" ; set manual contour levels
resc@cnFillColors =(/ 58, 74, 90, 96, 144, 170, 186, 202/)
resc@cnMinLevelValF        = -12         ; set min contour level
resc@cnMaxLevelValF        = 12         ; set max contour level
resc@cnLevelSpacingF       = 4          ; set contour interval

rest@cnLevelSelectionMode  = "ManualLevels" ; set manual contour levels
rest@cnMinLevelValF        = -0.6         ; set min contour level
rest@cnMaxLevelValF        =  0.6         ; set max contour level
rest@cnLevelSpacingF       =  0.2          ; set contour interval

resv                 = True  
resv@gsnDraw         = False
resv@gsnFrame        = False
resv@tmXBTickSpacingF =60
resv@tmYLTickSpacingF =30
resv@lbLabelFontHeightF = g_font
;resv@mpCenterLonF = 180.
resv@gsnMaximize      = True       ; fill up the page
resv@gsnLeftString   = " "                   
resv@gsnRightString  = " "                 
resv@tiMainOn               = False
;resv@mpFillOn               = False
;resv@mpGeophysicalLineThicknessF = l_thick
;resv@mpGridLineThicknessF   = l_thick
resv@tmXBLabelFontHeightF = g_font
resv@tmYLLabelFontHeightF = g_font
resv@vcGlyphStyle         = "FillArrow" ;  "CurlyVector" , "WindBarb"   
;; v箭头头部大小一致。若要绘制头部大小不一致箭头可参考第4章示例。

resv@vcFillArrowEdgeColor     = "black"
resv@vcFillArrowFillColor     = "black"
resv@vcGlyphOpacityF          = 1.0
resv@vcFillArrowMinFracWidthF = 0.2 
resv@vcFillArrowHeadMinFracXF = 0.2  
resv@vcFillArrowHeadMinFracYF = 0.2 
;; v参考箭头
resv@vcRefAnnoOn               = True  
resv@vcRefMagnitudeF           = 5      ;标准长度箭头所表示的大小
resv@vcRefLengthF              = 0.05  ;标准长度箭头在图形中的长度
resv@vcRefAnnoBackgroundColor  = "white" ;背景颜色     
resv@vcRefAnnoPerimOn          = False   ;关闭边框   
resv@vcRefAnnoFontHeightF      = 0.014   ;参考箭头标签字体大小      
resv@vcRefAnnoString1On        = False   ;设定参考箭头上、        
resv@vcRefAnnoString2On        = True    ;        下的字符
resv@vcRefAnnoString2          = "5 m/s" 
resv@vcRefAnnoOrthogonalPosF   = -0.25
resv@vcRefAnnoArrowUseVecColor = False
resv@vcRefAnnoArrowEdgeColor   ="black"
resv@vcRefAnnoArrowFillColor   ="black"
resv@vcMinDistanceF            = 0.02

res                  = True       ; use plot options
res@gsnLeftString   = ""                   
res@gsnRightString  = ""                 
res@gsnCenterString = " "
res@gsnFrame         = False
res@gsnDraw  = False
res@mpFillOn             = False        ; 不填色地图
res@mpCenterLonF         = 180          ; 地图的中心经度 
res@mpGeophysicalLineThicknessF = 0.5   ; 地图边界的粗细
res@pmTickMarkDisplayMode= "Always"     ; 坐标上标签上添加度符号
res@mpGridAndLimbOn      = True         ; 绘制经纬度线
res@mpGridLatSpacingF    = 30           ; 经纬度线间隔
res@mpGridLonSpacingF    = 60           ; 经纬度线间隔
res@mpGridLineDashPattern=2             ; 经纬度线线型取为类型为2的虚线。共17种线型供选择。
res@mpGridLineThicknessF =0.5           ; 其粗细

res@cnFillOn             = True         ; 填色等值线
res@cnLinesOn            = True         ; 绘制等值线
res@cnLineColor          = "white"      ; 颜色
res@cnLineThicknessF     = 0.3          ; 粗细
res@cnLineLabelsOn       = False        ; 关闭标签      
res@cnLevelSelectionMode  = "ExplicitLevels"                ; 指定每根需绘制的等值线
res@cnLevels              = (/0.01,0.05/)
res@cnFillPalette         = "GMT_gray"                      ; 用GMT_gray 进行填色。即调用了第2种色板
res@cnFillColors          = (/5,7,-1/)                      ; -1 为透明
res@cnInfoLabelOn         = False       ; 关闭图右下方的等值线信息标签
res@lbLabelBarOn          = False       ; 关闭labelbar

refmag = 5   ;参考箭头所表示的风速大小
do i = 0, 2, 1
    outfile    = "/home/ys17-19/cjx/figure/ENSO/comp-enso"+level(i)
    ;;;read data ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
    ;;  sst
    
    f_sst  =addfile("/home/ys17-19/cjx/observation_data/sst/HadISST_monthly_197901_201812.nc","r")
    sst_time   = f_sst->time              ; 读取其日期
    sst_YYYYMM=cd_calendar(sst_time,-1)       ; 转换成公历日期
    sst_start =ind(it_s .eq.sst_YYYYMM)
    sst_end =ind(it_e .eq.sst_YYYYMM)
    sst=f_sst->sst(sst_start:sst_end,:,:) ; 截取指定时间段
    
    ;; h_height 
    f_h = addfile("/home/ys17-19/cjx/observation_data/ERA-Interim/era_interim_z.nc", "r")
    h_time   = f_h->time              ; 读取其日期
    h_YYYYMM=cd_calendar(h_time,-1)       ; 转换成公历日期
    h_start =ind(it_s .eq.h_YYYYMM)
    h_end =ind(it_e .eq.h_YYYYMM)
    h=short2flt(f_h->z(h_start:h_end,{level(i)},:,:)) ; 截取指定时间段
    
    ;;; u_wind 
    f_u = addfile("/home/ys17-19/cjx/observation_data/ERA-Interim/era_interim_uv.nc", "r")
    u_time   = f_u->time              ; 读取其日期
    u_YYYYMM=cd_calendar(u_time,-1)       ; 转换成公历日期
    u_start =ind(it_s .eq.u_YYYYMM)
    u_end =ind(it_e .eq.u_YYYYMM)
    u=short2flt(f_u->u(u_start:u_end,{level(i)},:,:)) ; 截取指定时间段
    
    ;;; v_wind 
    v=short2flt(f_u->v(u_start:u_end,{level(i)},:,:)) ; 截取指定时间段
    
    ;;; air temperature 
    f_t = addfile("/home/ys17-19/cjx/observation_data/ERA-Interim/era_interim_t.nc", "r")
    t_time   = f_t->time              ; 读取其日期
    t_YYYYMM=cd_calendar(t_time,-1)       ; 转换成公历日期
    t_start =ind(it_s .eq.t_YYYYMM)
    t_end =ind(it_e .eq.t_YYYYMM)
    t=short2flt(f_t->t(t_start:t_end,{level(i)},:,:)) ; 截取指定时间段
    
    ;;;DJF 平均 & 异常 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    sst_temp=sst
    sst(:,:,{-179.5:-0.5})=(/sst(:,:,{0.5:179.5})/)
    sst(:,:,{0.5:179.5})=(/sst_temp(:,:,{-179.5:-0.5})/)
    delete(sst_temp)
    sst&longitude=fspan(0.5,359.5,360)
    sst_DJF=month_to_season(sst,"JFM")
    ;JFM季节平均，实际是12/1/2月三个月平均，因为从1979年12月开始截取
    copy_VarMeta(sst(0,:,:),sst_DJF(0,:,:))
    sst_DJF!0 = "year"
    sst_DJF&year=year 
    printVarSummary(sst_DJF)
    
    ;;; h
    h_MAM = month_to_season(h, "AMJ") 
    copy_VarMeta(h(0,:,:),h_MAM(0,:,:))
    h_MAM!0 = "year"
    h_MAM&year=year 
    
    h_ano = dim_rmvmean_n_Wrap(h_MAM,0)
    
    ;;; u 与h 同维  
    u_MAM = (/month_to_season(u, "AMJ")/) 
    copy_VarMeta(h_MAM,u_MAM)
    
    u_ano = dim_rmvmean_n_Wrap(u_MAM,0)
    
    ;; v 与h 同维  
    v_MAM = (/month_to_season(v, "AMJ")/) 
    copy_VarMeta(h_MAM,v_MAM)   
    
    v_ano = dim_rmvmean_n_Wrap(v_MAM,0)
    
    ;; t
    t_MAM = (/month_to_season(t, "AMJ")/) 
    copy_VarMeta(t(0,:,:),t_MAM(0,:,:))
    t_MAM!0   ="year"
    t_MAM&year=year   
    
    t_ano = dim_rmvmean_n_Wrap(t_MAM,0)
    
    ;;;(3) enso index (5N-5S, 170-120W);;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
    ; 0表示仅用非缺省的数值进行计算 
    ;1 表示标准化时除以的是[N] ; 而0表示除以[N-1]
    
    ;; 输出至netcdf文件
    ensoi = wgt_areaave_Wrap(sst_DJF(:,{-5:5},{190:240}),1.,1.,0)
    ensoi = dim_standardize_Wrap(ensoi,1)
    
    ;;;(4) composite ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    irec_positive=ind(ensoi .lt. 0.8 .and. ensoi .gt. -0.8)
    nnumb = dimsizes(irec_positive) 
    
    
    h_comp  = dim_avg_n_Wrap(h_ano(irec_positive,:,:),0) 
    u_comp  = dim_avg_n_Wrap(u_ano(irec_positive,:,:),0)    
    v_comp  = dim_avg_n_Wrap(v_ano(irec_positive,:,:),0) 
    t_comp = dim_avg_n_Wrap(t_ano(irec_positive,:,:),0) 
    printMinMax(t_comp, 0)
    
    ;;;; (5) t-test ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    ;;; h
    h_std = dim_variance_n_Wrap(h_ano(irec_positive,:,:),0)
    h_std = sqrt(h_std/nnumb)
    t_h   = h_comp/h_std       
    confi_h = h_comp
    confi_h = student_t(t_h, nnumb-1)   
    
    ;;; t
    t_std = dim_variance_n_Wrap(t_ano(irec_positive,:,:),0)
    t_std = sqrt(t_std/nnumb)
    t_t   = t_comp/t_std       
    confi_t = t_comp
    confi_t = student_t(t_t, nnumb-1) 
    
    ;;;; (5) plot
    wks = gsn_open_wks("x11",outfile)
    gsn_define_colormap(wks,"BlueWhiteOrangeRed")
    
    base = new(2,"graphic")
    plot = new(2,"graphic")  
    
    resc@gsnCenterString = "h & wind "+level(i)  
    
    ;base(0) = gsn_csm_contour_map(wks,confi_h,res)  
    plot(0) = gsn_csm_contour_map(wks,h_comp,resc) 
    ;overlay(base(0),plot(0))
    ;draw(base(0))
    ;frame(wks)
    
    plotv   = gsn_csm_vector(wks,u_comp,v_comp,resv) 
    overlay(plot(0),plotv)  ; 也可用gsn_csm_vector_map(wks,h_comp,u,v,res_new)
    
    rest@gsnCenterString = "t "+level(i)  
    ;base(1) = gsn_csm_contour_map(wks,confi_t,res)  
    plot(1) = gsn_csm_contour_map(wks,t_comp,rest) 
    ;overlay(base(1),plot(1))  
    
    resP = True                        ; 绘制panel图
    resP@txString       = "Composite analysis -enso"    ; 添加主标题
    resP@txFontHeightF  = 0.02         ; 修改其大小  
    
    ;resP@gsnPanelFigureStrings= (/"a)","b)"/)  ;各个子图的标号
    resP@gsnPanelFigureStringsFontHeightF = 0.015   ;字体的大小 
    resP@amJust = "TopLeft"                         ;摆放的位置，默认是“BottomRight”
    
    resP@gsnPanelRowSpec = True       ; 指定每行绘制的子图的个数
    gsn_panel(wks,plot,(/2/),resP)        ; 第1行绘制1幅，第2行绘制2幅
end do
end
