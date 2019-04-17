
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
    g_data_path4="/home/ys17-19/cjx/observation_data/olr.mon.mean.nc"
    g_data_path5="/home/ys17-19/cjx/observation_data/air.mon.mean.nc"
    
    l_thick= 2
    range=6
    ;Fig region
    g_figlatS=-30
    g_figlatN=50
    g_figlonE=30
    g_figlonW=300

    ;Nino 3
    g_latS=-5.
    g_latN=5.
    g_lonW=190.
    g_lonE=240.

    
    g_font = 0.018

    g_strt_mon = 197901 
    g_lst_mon = 201812
    outfile    = "/home/ys17-19/cjx/figure/PCOR_new/ts_olr"

;*************************For F_Compset Ctrl***********************************

; ==============================================================
; Mission 1. Open the file: Read only the user specified period
; ==============================================================

	ctrl_file1   = g_data_path
	ctrl_file4   = g_data_path4
	ctrl_file5   = g_data_path5
	ctrl_in1     = addfile (ctrl_file1, "r")   ; note the "s" of addfile
	ctrl_in4     = addfile (ctrl_file4, "r")   ; note the "s" of addfile
	ctrl_in5     = addfile (ctrl_file5, "r")   ; note the "s" of addfile
	time_hist    = ctrl_in1->time
    time_olr     = ctrl_in4->time
    time_var     = ctrl_in5->time
    yyyymm  = cd_calendar(time_hist,-1)
    yyyymm_olr  = cd_calendar(time_olr,-1)
    yyyymm_var  = cd_calendar(time_var,-1)
    istrt   = ind(yyyymm .eq. g_strt_mon)
    ilast   = ind(yyyymm .eq. g_lst_mon)
    istrt_olr   = ind(yyyymm_olr .eq. g_strt_mon)
    istrt_var   = ind(yyyymm_var .eq. g_strt_mon)
    ilast_var   = ind(yyyymm_var .eq. g_lst_mon)
    ilast_olr   = ind(yyyymm_olr .eq. g_lst_mon)
	var1  =ctrl_in1->sst(istrt:ilast,:,:)			; p for unify the var name
	var4  =ctrl_in4->olr(istrt_olr:ilast_olr,:,:)			; p for unify the var name
	var5  =ctrl_in5->air(istrt_var:ilast_var,:,:)			; p for unify the var name

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
 
    delete(var1)
    var1 =var5
    pr12_3=var1(0,:,:)
    pr12_3sig=var1(0,:,:)
    psig = 0.05

    r23_temp=escorc(olr,nino3)
    r23=pr12_3
    r23=(/r23_temp/)

    years=dimsizes(nino3)

        
        var1_ssn:=month_to_season(var1,"MAM")
        
        r12=escorc(olr,var1_ssn(lat|:,lon|:,time|:))
        r13=escorc(nino3,var1_ssn(lat|:,lon|:,time|:))
        pr12_3=(/(r12-r13*r23)/(sqrt(1-r13*r13)*sqrt(1-r23*r23))/)

        ; significance test
        n = years
        df= n-1-2
        t=pr12_3*sqrt(df)/sqrt(1-pr12_3*pr12_3)
       
        p=student_t(t,df)
        pr12_3sig=where(p .le. psig, pr12_3, pr12_3@_FillValue)

; ==============================================================
; Mission 3. Set plot parameters and plot
; ==============================================================


;-----------------------------------------------------------------------------
          
  plot1 = new(1,"graphic")
  plot2 = new(1,"graphic")
  wks = gsn_open_wks("png",outfile)  ; open a ps file
  gsn_define_colormap(wks,"BlueWhiteOrangeRed")
   
  res                 = True  
  res@gsnDraw         = False
  res@gsnFrame        = False
  res@gsnMaximize      = True       ; fill up the page
  res@gsnLeftString   = ""                   
  res@gsnRightString  = ""                 
  res@gsnCenterString  = ""                 
  res@gsnCenterString = " PCOR TS&olr -nino3 "
  res@mpCenterLonF = 180.
;  res@gsnCenterStringFontHeightF = g_font  
   res@mpFillOn               = False
   res@mpGeophysicalLineThicknessF = l_thick
   res@mpGridLineThicknessF   = l_thick
;   res@mpLandFillColor        = "blue"
;  res@mpGridSpacingF         = 10.     ;
  ;res@pmTickMarkDisplayMode = "Always"
  res@cnLevelSelectionMode  = "ManualLevels" ; set manual contour levels
;  res@cnLevels      =(/-400, -300,-1000,-100, 0, 100 ,400,800, 11000,1600,10000 /)
 ; res@cnFillColors =(/10,26,42,58,74,90,106,122,138,154,170,186,202,218,234,250/)
  res@cnFillColors =(/ 42, 58, 74, 90, 96, 144, 170, 186, 202, 218/)
  res@cnMinLevelValF        = -0.4         ; set min contour level
  res@cnMaxLevelValF        = 0.4         ; set max contour level
  res@cnLevelSpacingF       = 0.1          ; set contour interval
  res@cnFillOn      = True                  
  res@cnLinesOn     = False                 
  res@lbLabelFontHeightF = g_font
  res@tmYLMajorLengthF=0.01
  res@tmXBMajorLengthF=0.01
  res@tmXBLabelFontHeightF = g_font
  res@tmYLLabelFontHeightF = g_font
  res@tmXBTickSpacingF =60
  res@tmYLTickSpacingF =30
  res@pmLabelBarOrthogonalPosF = 0.15
  ;res@mpMaxLatF=g_figlatN
  ;res@mpMinLatF=g_figlatS
  ;res@mpMaxLonF=g_figlonW
  ;res@mpMinLonF=g_figlonE

  res4                  = True       ; use plot options
  res4@lbLabelBarOn     = False
  res4@gsnLeftString   = ""                   
  res4@gsnRightString  = ""                 
  res4@gsnCenterString = " "
  res4@cnFillOn         = True       ; Fill contours
  res4@cnLinesOn        = False;True      ; turn off contour lines
  res4@gsnFrame         = False
  res4@gsnDraw  = False
  res4@cnLineLabelsOn   = False      ; turn off contour line labels
  res4@cnLineThicknessF = 2
  res4@cnLineColor      = "black"
  res4@cnInfoLabelOn = False
  res4@cnMonoFillPattern    = True;False
  res4@cnFillPattern = 17
  res4@cnMonoFillScale = True
  res4@cnFillScaleF = 1.
  res4@cnMonoFillColor = True
  res4@cnFillColor  =  "black"
  res4@cnFillDotSizeF = 0.004
;--------------------------------------

  plot1 = gsn_csm_contour_map(wks,pr12_3,res)
  plot2 = gsn_csm_contour(wks,pr12_3sig,res4)
  polyres                   = True
  polyres@gsMarkerIndex     = 10          ; polymarker style
  polyres@gsMarkerSizeF     = 16.          ; polymarker size
  polyres@gsMarkerThicknessF     = 6.          ; polymarker size
  polyres@gsMarkerColor     = "green"          ; polymarker size
  plot1@$unique_string("fxxk ncl")$    = gsn_add_polymarker(wks,plot1,115,0,polyres)
  overlay(plot1,plot2)
  draw(plot1)
  frame(wks)

end 
