
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin


;================================================
;Variables List:
;	var1--------------TS
;================================================
;global variables
    ;Define parameters
    g_data_path = "/home/ys17-19/cjx/observation_data/sst/HadISST_monthly_197901_201812.nc"
    g_data_path2="/home/ys17-19/cjx/observation_data/uwnd.mon.mean.nc"
    g_data_path3="/home/ys17-19/cjx/observation_data/vwnd.mon.mean.nc"
    g_data_path4="/home/ys17-19/cjx/observation_data/olr.mon.mean.nc"
    ;g_data_path5="/home/ys17-19/cjx/observation_data/ERA-Interim/era_interim_t.nc"
    level=(/200,500,850,1000/)
    range=6
    ;Fig region
    g_figlatS=-30
    g_figlatN=50
    g_figlonE=30
    g_figlonW=300

    ;Nino 3
    g_latS=-5.
    g_latN=5.
    g_lonW=210.
    g_lonE=270.

    
    g_font = 0.018
    l_thick= 2
    g_strt_mon = 197901 
    g_lst_mon = 201812
    do j=0,3,1
    outfile="/home/ys17-19/cjx/figure/PCOR_new/wind"+level(j)+"_olr"
;*************************For F_Compset Ctrl***********************************

; ==============================================================
; Mission 1. Open the file: Read only the user specified period
; ==============================================================

	ctrl_file1   = g_data_path
	ctrl_file2   = g_data_path2
	ctrl_file3   = g_data_path3
	ctrl_file4   = g_data_path4
	ctrl_in1     = addfile (ctrl_file1, "r")   ; note the "s" of addfile
	ctrl_in2     = addfile (ctrl_file2, "r")   ; note the "s" of addfile
	ctrl_in3     = addfile (ctrl_file3, "r")   ; note the "s" of addfile
	ctrl_in4     = addfile (ctrl_file4, "r")   ; note the "s" of addfile
	time_hist    = ctrl_in1->time
    time_uv      = ctrl_in2->time
    time_olr     = ctrl_in4->time
    yyyymm  = cd_calendar(time_hist,-1)
    yyyymm_uv=cd_calendar(time_uv,-1)
    yyyymm_olr  = cd_calendar(time_olr,-1)
    istrt   = ind(yyyymm .eq. g_strt_mon)
    ilast   = ind(yyyymm .eq. g_lst_mon)
    istrt_uv   = ind(yyyymm_uv .eq. g_strt_mon)
    ilast_uv   = ind(yyyymm_uv .eq. g_lst_mon)
    istrt_olr   = ind(yyyymm_olr .eq. g_strt_mon)
    ilast_olr   = ind(yyyymm_olr .eq. g_lst_mon)
	var1  =ctrl_in1->sst(istrt:ilast,:,:)			; p for unify the var name
	var2  =ctrl_in2->uwnd(istrt_uv:ilast_uv,{level(j)},:,:)			; p for unify the var name
	var3  =ctrl_in3->vwnd(istrt_uv:ilast_uv,{level(j)},:,:)			; p for unify the var name
	var4  =ctrl_in4->olr(istrt_olr:ilast_olr,:,:)			; p for unify the var name

;-----count nino3---------------------------------------------------
    var1_temp=var1
    var1(:,:,{-179.5:-0.5})=(/var1(:,:,{0.5:179.5})/)
    var1(:,:,{0.5:179.5})=(/var1_temp(:,:,{-179.5:-0.5})/)
    delete(var1_temp)
    var1&longitude=fspan(0.5,359.5,360)
    var1_djf=month_to_season(var1,"DJF")
    nino3=wgt_areaave_Wrap(var1_djf(:,{g_latS:g_latN},{g_lonW:g_lonE}), 1.0, 1.0, 0)
    printVarSummary(nino3)

;----count olr in MC----------------------------------------------------
	olr_in  =short2flt(var4)			; p for unify the var name
    pre_olr =olr_in(time|:,{lat | 0-range:0+range},{lon | 115-range:115+range})
    pre_olr_ssn = month_to_season(pre_olr,"MAM")
    printVarSummary(pre_olr_ssn)
    olr = wgt_areaave(pre_olr_ssn,1.0,1.0,0)
    printVarSummary(olr)

;-----------------------------------------------------------------
   ;change    sst     --- 1   to var --1
   ;change    nino3   --- 2      olr --2
   ;change    emi     --- 3      nino3-3
;-------------------------------------------------------------------
 
    pr12_3=var2(0,:,:)
    pr12_3_u=var2(0,:,:)
    pr12_3_usig=var2(0,:,:)
    pr12_3_vsig=var3(0,:,:)
    pr12_3_v=var3(0,:,:)
    psig = 0.05

    r23_temp=escorc(olr,nino3)
    r23=pr12_3
    r23=(/r23_temp/)

    r23_uv=pr12_3_u
    r23_uv=(/r23_temp/)
    years=dimsizes(nino3)

        
        var2_ssn:=month_to_season(var2,"MAM")
        var3_ssn:=month_to_season(var3,"MAM")
        
        r12_u=escorc(olr,var2_ssn(lat|:,lon|:,time|:))
        r13_u=escorc(nino3,var2_ssn(lat|:,lon|:,time|:))
        pr12_3_u=(/(r12_u-r13_u*r23_uv)/(sqrt(1-r13_u*r13_u)*sqrt(1-r23_uv*r23_uv))/)
        
        r12_v=escorc(olr,var3_ssn(lat|:,lon|:,time|:))
        r13_v=escorc(nino3,var3_ssn(lat|:,lon|:,time|:))
        pr12_3_v=(/(r12_v-r13_v*r23_uv)/(sqrt(1-r13_v*r13_v)*sqrt(1-r23_uv*r23_uv))/)
        
        ; significance test
        n = years
        df= n-1-2
        t_u=pr12_3_u*sqrt(df)/sqrt(1-pr12_3_u*pr12_3_u)
        t_v=pr12_3_v*sqrt(df)/sqrt(1-pr12_3_v*pr12_3_v)
        
        p_u=student_t(t_u,df)
        p_v=student_t(t_v,df)
        pr12_3_usig=where(p_u .le. psig .or. p_v .le. psig, pr12_3_u, pr12_3_u@_FillValue)
        pr12_3_vsig=where(p_u .le. psig .or. p_v .le. psig, pr12_3_v, pr12_3_u@_FillValue)
        pr12_3_u=where(p_u .ge. psig .and. p_v .ge. psig, pr12_3_u, pr12_3_u@_FillValue)
        pr12_3_v=where(p_u .ge. psig .and. p_v .ge. psig, pr12_3_v, pr12_3_u@_FillValue)

; ==============================================================
; Mission 3. Set plot parameters and plot
; ==============================================================

    plot1 = new(1,"graphic")
    plot2 = new(1,"graphic")
   
  wks = gsn_open_wks("png",outfile)     
  gsn_define_colormap(wks,"GrayWhiteGray")
   
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
  ;res@gsnCenterString  = " "                 
  res@gsnCenterString = " PCOR Wind"+level(j)+"&olr -nino3 " 
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
  res@vcRefAnnoOn               = False;True  
  res@vcRefMagnitudeF           = 1      ;标准长度箭头所表示的大小
  res@vcRefLengthF              = 0.05  ;标准长度箭头在图形中的长度
  res@vcRefAnnoBackgroundColor  = "white" ;背景颜色     
  res@vcRefAnnoPerimOn          = False   ;关闭边框   
  res@vcRefAnnoFontHeightF      = 0.014   ;参考箭头标签字体大小      
  res@vcRefAnnoString1On        = False   ;设定参考箭头上、        
  res@vcRefAnnoString2On        = True    ;        下的字符
  res@vcRefAnnoString2          = "1 m/s" 
  res@vcRefAnnoOrthogonalPosF   = 0.155
  res@vcRefAnnoArrowUseVecColor = False
  res@vcRefAnnoArrowEdgeColor   ="black"
  res@vcRefAnnoArrowFillColor   ="black"
  res@vcMinDistanceF            = 0.02
  ;res@mpMaxLatF=g_figlatN
  ;res@mpMinLatF=g_figlatS
  ;res@mpMaxLonF=g_figlonW
  ;res@mpMinLonF=g_figlonE

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
  res4@vcRefMagnitudeF           = 1      ;标准长度箭头所表示的大小
  res4@vcRefLengthF              = 0.05  ;标准长度箭头在图形中的长度
  res4@vcRefAnnoBackgroundColor  = "white" ;背景颜色     
  res4@vcRefAnnoPerimOn          = False   ;关闭边框   
  res4@vcRefAnnoFontHeightF      = 0.014   ;参考箭头标签字体大小      
  res4@vcRefAnnoString1On        = False   ;设定参考箭头上、        
  res4@vcRefAnnoString2On        = True    ;        下的字符
  res4@vcRefAnnoString2          = "1 m/s" 
  res4@vcRefAnnoOrthogonalPosF   = 0.155
  res4@vcMinDistanceF            = 0.02
  res4@vcRefAnnoArrowEdgeColor   ="black"
  res4@vcRefAnnoArrowFillColor   ="black"

  plot1 = gsn_csm_vector_map(wks,pr12_3_u,pr12_3_v,res)
  plot2 = gsn_csm_vector(wks,pr12_3_usig,pr12_3_vsig,res4)
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
end 
