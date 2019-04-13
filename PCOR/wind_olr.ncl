;*************************************************************
;Aim: draw TS monthly change ratio 
;   R=((T/2)*tr(TSapr))/clim(TSmay-TSapr))
;
;Mission:
;   1. Read data from GISS-LOT data
;   2. Post-post process
;     2.1 take the trend of a specific month
;     2.2 caculate the trend of 
;   4. Draw and overlap
;                       Zhenning Li
;                       2015-05-07
;Last Edited:
;   2015-03-01  Create
;   2015-03-03  Change to fit HEAT Experiment
;   2015-04-05  Change to fit Team Server
;   2015-04-08  Change to fit ECMWF MONLTM MEAN
;   2015-04-20  Change to caculate SST trend
;   2015-05-07  Change to caculate TS change trend
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin
level=(/200,500,850,1000/)
lon_array=(/10.0, 115.0, 140.0, 155.0, 231.0,  284.0, 310.0/)
lat_array=(/0.0,  0.0,   -5.0,  5.0,   5.0,    0.0,   0.0/)
range =6
g_font = 0.025
l_thick= 2


;================================================
;Variables List:
;	var1--------------TS
;================================================


;global variables
    ;Define parameters
    g_data_path = "/home/ys17-19/cjx/observation_data/sst/HadISST_monthly_197901_201812.nc"
    g_data_path2="/home/ys17-19/cjx/observation_data/olr.mon.mean.nc"
    g_data_path3="/home/ys17-19/cjx/observation_data/ERA-Interim/era_interim_uv.nc"

    ;Fig region
    g_figlatS=-70
    g_figlatN=70
    g_figlonE=90
    g_figlonW=280

    ;Nino 3
    g_latS=-5.
    g_latN=5.
    g_lonW=210.
    g_lonE=270.

; create an array of desired pressure levels:

do j=0,3,1        
do i=1,1,1
    g_font = 0.018
    g_season = "MAM"
    g_strt_mon = 197901 
    g_lst_mon = 201812
    g_fig_name    =   "/home/ys17-19/cjx/figure/PCOR/PCOR wind&olr"+level(j)+" -nino3"
   ; g_fig_title     = " PCOR ("+(/"JJA", "SON", "DJF", "MAM1", "JJA1"/)+" SSTA & Wind850, DJF Nino3)"


;*************************For F_Compset Ctrl***********************************

; ==============================================================
; Mission 1. Open the file: Read only the user specified period
; ==============================================================

	ctrl_file1   = g_data_path
	ctrl_file2   = g_data_path2
	ctrl_file3   = g_data_path3
	ctrl_in1     = addfile (ctrl_file1, "r")   ; note the "s" of addfile
	ctrl_in2     = addfile (ctrl_file2, "r")   ; note the "s" of addfile
	ctrl_in3     = addfile (ctrl_file3, "r")   ; note the "s" of addfile
	time_hist    = ctrl_in1->time
    time_prec      = ctrl_in2->time
    time_z500      = ctrl_in3->time
    yyyymm  = cd_calendar(time_hist,-1)
    yyyymm_prec=cd_calendar(time_prec,-1)
    yyyymm_z500=cd_calendar(time_z500,-1)
    istrt   = ind(yyyymm .eq. g_strt_mon)
    ilast   = ind(yyyymm .eq. g_lst_mon)
    istrt_prec   = ind(yyyymm_prec .eq. g_strt_mon)
    ilast_prec   = ind(yyyymm_prec .eq. g_lst_mon)
    istrt_z500   = ind(yyyymm_z500 .eq. g_strt_mon)
    ilast_z500   = ind(yyyymm_z500 .eq. g_lst_mon)
	var1  =ctrl_in1->sst(istrt:ilast,:,:)			; p for unify the var name
	precc  =short2flt(ctrl_in2->olr(istrt_prec:ilast_prec,:,:))			; p for unify the var name
   ; pre_precc =precc(time|:,{latitude | -10:10},{longitude | 105:125})
    pre_precc =precc(time|:,{lat | lat_array(i)-range:lat_array(i)+range},{lon | lon_array(i)-range:lon_array(i)+range})
    pre_precc_c=pre_precc
    pre_precc_c=pre_precc/24.0
    pre_precc_ssn = month_to_season(pre_precc_c,"MAM")
    printVarSummary(pre_precc_ssn)
    precip = wgt_areaave(pre_precc_ssn,1.0,1.0,0)
    printVarSummary(precip)
    var1_temp=var1
    var1(:,:,{-179.5:-0.5})=(/var1(:,:,{0.5:179.5})/)
    var1(:,:,{0.5:179.5})=(/var1_temp(:,:,{-179.5:-0.5})/)
    delete(var1_temp)
    var1&longitude=fspan(0.5,359.5,360)

    var1_djf=month_to_season(var1,"DJF")
    nino3=wgt_areaave_Wrap(var1_djf(:,{g_latS:g_latN},{g_lonW:g_lonE}), 1.0, 1.0, 0)
  

;----------------------------------------------
;change    ;   sst     --- 1   to  z500   ----1
           ;  nino3    --- 2       precip ----2
           ;   emi     --- 3       nino3  ----3
;----------------------------------------------

	U  =short2flt(ctrl_in3->u(istrt_z500:ilast_z500,{level(j)},:,:))			; p for unify the var name

    Upr12_3=U(0,:,:)
    psig = 0.05
    Ur23_temp=escorc(precip,nino3)
    printVarSummary(Ur23_temp)
    Ur23=Upr12_3
    printVarSummary(Ur23)
    Ur23=(/Ur23_temp/)

    years=dimsizes(nino3)

    U_ssntemp=month_to_season(U,g_season)
    U_ssn:=U_ssntemp(latitude|:,longitude|:,time|:)
    U_ssn:=U_ssn(:,:,0:years-2)

    Ur12=escorc(precip(1:),U_ssn)
    Ur13=escorc(nino3(1:),U_ssn)
    Upr12_3=(/(Ur12-Ur13*Ur23)/(sqrt(1-Ur13*Ur13)*sqrt(1-Ur23*Ur23))/)
    ; print(Upr12_3)
    ; significance test
    n = years-1 
    df= n-1-2
    Ut=Upr12_3*sqrt(df)/sqrt(1-Upr12_3*Upr12_3)
    Up=student_t(Ut,df)
    Usig=Upr12_3
    Usig=where(Up .le. psig, Upr12_3, Upr12_3@_FillValue)

	V  =short2flt(ctrl_in3->v(istrt_z500:ilast_z500,{level(j)},:,:))			; p for unify the var name

    Vpr12_3=V(0,:,:)
    psig = 0.05
    Vr23_temp=escorc(precip,nino3)
    printVarSummary(Vr23_temp)
    Vr23=Vpr12_3
    printVarSummary(Vr23)
    Vr23=(/Vr23_temp/)

    years=dimsizes(nino3)

    V_ssntemp=month_to_season(V,g_season)
    V_ssn:=V_ssntemp(latitude|:,longitude|:,time|:)
    V_ssn:=V_ssn(:,:,0:years-2)

    Vr12=escorc(precip(1:),V_ssn)
    Vr13=escorc(nino3(1:),V_ssn)
    Vpr12_3=(/(Vr12-Vr13*Vr23)/(sqrt(1-Vr13*Vr13)*sqrt(1-Vr23*Vr23))/)
    ; print(Vpr12_3)
    ; significance test
    n = years-1 
    df= n-1-2
    Vt=Vpr12_3*sqrt(df)/sqrt(1-Vpr12_3*Vpr12_3)
    Vp=student_t(Vt,df)
    Vsig=Vpr12_3
    Vsig=where(Vp .le. psig, Vpr12_3, Vpr12_3@_FillValue)


; ==============================================================

wks = gsn_open_wks("png",g_fig_name)  ; open a ps file
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
  res@gsnCenterString = "PCOR olr&wind"+level(j)+" -nino3"
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
  res@vcGlyphOpacityF           =0.3
  res@vcFillArrowMinFracWidthF = 0.3 
  res@vcFillArrowHeadMinFracXF = 0.3  
  res@vcFillArrowHeadMinFracYF = 0.3 
  ;; 参考箭头
  res@vcRefAnnoOn               = False  
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
  res@vcMinDistanceF            = 0.02
  ;res@mpMaxLatF=g_figlatN
  ;res@mpMinLatF=g_figlatS
  ;res@mpMaxLonF=g_figlonW
  ;res@mpMinLonF=g_figlonE

  res4                 = True  
  res4@gsnDraw         = False
  res4@gsnFrame        = False
  ;res4@lbLabelFontHeightF = g_font
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
  res4@vcRefMagnitudeF           = 0.5      ;标准长度箭头所表示的大小
  res4@vcRefLengthF              = 0.05  ;标准长度箭头在图形中的长度
  res4@vcRefAnnoBackgroundColor  = "white" ;背景颜色     
  res4@vcRefAnnoPerimOn          = False   ;关闭边框   
  res4@vcRefAnnoFontHeightF      = 0.014   ;参考箭头标签字体大小      
  res4@vcRefAnnoString1On        = False   ;设定参考箭头上、        
  res4@vcRefAnnoString2On        = True    ;        下的字符
  res4@vcRefAnnoString2          = "0.5 m/s" 
  res4@vcRefAnnoOrthogonalPosF   = 0.155
  res4@vcMinDistanceF            = 0.02
  res4@vcRefAnnoArrowEdgeColor   ="black"
  res4@vcRefAnnoArrowFillColor   ="black"
;-----------------------------------------------------------------------------
  plot1 = gsn_csm_vector_map(wks,Upr12_3,Vpr12_3,res)
  plot2 = gsn_csm_vector(wks,Usig,Vsig,res4)
  polyres                   = True
  polyres@gsMarkerIndex     = 2          ; polymarker style
  polyres@gsMarkerSizeF     = 16.          ; polymarker size
  polyres@gsMarkerThicknessF     = 6.          ; polymarker size
  polyres@gsMarkerColor     = "green"          ; polymarker size
  plot1@$unique_string("fxxk ncl")$    = gsn_add_polymarker(wks,plot1,lon_array(i),lat_array(i),polyres)
  overlay(plot1,plot2)
  draw(plot1)
  frame(wks)
  delete(var1)
end do
end do
end 
