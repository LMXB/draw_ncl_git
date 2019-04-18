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

range =6
g_font = 0.025
l_thick= 2

    ; Central
    g_clatS=-10.
    g_clatN=10.
    g_clonW=165.
    g_clonE=220.
    
    ; Eastern
    g_elatS=-15.
    g_elatN=5.
    g_elonW=250.
    g_elonE=290.
    
    
    ; Western 
    g_wlatS=-10.
    g_wlatN=20.
    g_wlonW=125.
    g_wlonE=145.
    
    

;================================================
;Variables List:
;	var1--------------TS
;================================================


;global variables
    ;Define parameters
    g_data_path = "/home/ys17-19/cjx/observation_data/sst/HadISST_monthly_197901_201812.nc"
    g_data_path2="/home/ys17-19/cjx/observation_data/olr.mon.mean.nc"
    g_data_path3="/home/ys17-19/cjx/observation_data/ERA-Interim/era_interim_z.nc"

    ;Fig region
    g_figlatS=-30
    g_figlatN=50
    g_figlonE=30
    g_figlonW=200

    ;Nino 3
    g_latS=-5.
    g_latN=5.
    g_lonW=210.
    g_lonE=270.

; create an array of desired pressure levels:

        
;do i=1,1,1
    g_font = 0.018
    g_season = "MAM"
    g_strt_mon = 197901 
    g_lst_mon = 201812
    g_fig_name    =   "/home/ys17-19/cjx/figure/PCOR/PCOR precip in area&z500 -nino3"
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
	;precc  =short2flt(ctrl_in2->olr(istrt_prec:ilast_prec,:,:))			; p for unify the var name
   ;; pre_precc =precc(time|:,{latitude | -10:10},{longitude | 105:125})
    ;pre_precc =precc(time|:,{lat | 0-range:0+range},{lon | 115-range:115+range})
    ;pre_precc_ssn = month_to_season(pre_precc,"MAM")
    ;printVarSummary(pre_precc_ssn)
    ;olr = wgt_areaave(pre_precc_ssn,1.0,1.0,0)
    ;printVarSummary(olr)
    var1_temp=var1
    var1(:,:,{-179.5:-0.5})=(/var1(:,:,{0.5:179.5})/)
    var1(:,:,{0.5:179.5})=(/var1_temp(:,:,{-179.5:-0.5})/)
    delete(var1_temp)
    var1&longitude=fspan(0.5,359.5,360)

    var1_djf=month_to_season(var1,"DJF")
    nino3=wgt_areaave_Wrap(var1_djf(:,{g_latS:g_latN},{g_lonW:g_lonE}), 1.0, 1.0, 0)
  
    w_p=wgt_areaave_Wrap(var1_djf(:,{g_wlatS:g_wlatN},{g_wlonW:g_wlonE}), 1.0, 1.0, 0)
    c_p=wgt_areaave_Wrap(var1_djf(:,{g_clatS:g_clatN},{g_clonW:g_clonE}), 1.0, 1.0, 0)
    e_p=wgt_areaave_Wrap(var1_djf(:,{g_elatS:g_elatN},{g_elonW:g_elonE}), 1.0, 1.0, 0)

    emi=w_p
    emi=c_p-0.5*e_p-0.5*w_p

;----------------------------------------------
;change    ;   sst     --- 1   to  z500   ----1
           ;  nino3    --- 2       precip ----2
           ;   emi     --- 3       nino3  ----3
;----------------------------------------------

    ;delete(var1)  
	;var1  =short2flt(ctrl_in3->z(istrt_z500:ilast_z500,{500},:,:))			; p for unify the var name
    pr12_3=var1(0,:,:)
    psig = 0.05
    r23_temp=escorc(emi,nino3)
    printVarSummary(r23_temp)
    r23=pr12_3
    printVarSummary(r23)
    r23=(/r23_temp/)

    years=dimsizes(nino3)

    ; JJA SON
   ; do ii = 0, 1
        var1_ssn:=month_to_season(var1,"MAM")        
        r12=escorc(nino3,var1_ssn(latitude|:,longitude|:,time|:))
        r13=escorc(emi,var1_ssn(latitude|:,longitude|:,time|:))
        pr12_3=(/(r12-r13*r23)/(sqrt(1-r13*r13)*sqrt(1-r23*r23))/)
        ; significance test
        n = years 
        df= n-1-2
        t=pr12_3*sqrt(df)/sqrt(1-pr12_3*pr12_3)
        p=student_t(t,df)
        sig=pr12_3
        sig=where(p .le. psig, pr12_3, pr12_3@_FillValue)
   ; end do
; ==============================================================
; Mission 3. Set plot parameters and plot
; ==============================================================

wks = gsn_open_wks("x11",g_fig_name)  ; open a ps file
;gsn_define_colormap(wks,"BlueWhiteOrangeRed")
 gsn_define_colormap(wks,"temp_diff_18lev")


;-----------------------------------------------------------------------------

    plot1 = new(1,"graphic")
    plot2 = new(1,"graphic")
  res                  = True       ; use plot options

  res@cnFillOn             = True               ; turn on color for contours
  res@cnLinesOn            = False              ; turn off contour lines
  res@cnLineLabelsOn       = False              ; turn off contour line labels



 ; i = NhlNewColor(wks,0.341,0.,0.533)              ; add gray to colormap
 ; j = NhlNewColor(wks,1,0.,0.)
;  res@mpLandFillColor       = "gray"            ; set land to be gray

  res@cnLevelSelectionMode = "ExplicitLevels"   ; set manual contour levels
  res@cnLevels = (/-0.45,-0.35,0.35,0.45/)
;   res@cnLevels = ispan(0,60,10)
;  res@cnFillColors =(/-1,20,47,57,94,127,152/)
;    res@cnLevelSelectionMode = "ExplicitLevels"   ; set manual contour levels
;    res@cnLevels =    (/-0.8,-0.4,-0.2, 0.0, 0.2, 0.4, 0.6, 0.8, 1.0, 1.5, 2.0, 2.5, 3.0/)
;    res@cnFillColors =(/   2,  18,  34,  52,  61,  68,  77,  82,  87,  91,  95,  99, 100, 102/)

; res@cnLevelSelectionMode  = "ManualLevels" ; set manual contour levels
; res@cnMinLevelValF        = -1.          ; set min contour level
; res@cnMaxLevelValF        = 1.          ; set max contour level
; res@cnLevelSpacingF       = 0.05         ; set contour interval

  res@cnFillColors =(/5,8,10,12,15/)


  res@gsnFrame         = False
  res@gsnDraw  = False
  
  res@gsnSpreadColors      = True               ; use full color map
;  res@gsnSpreadColorStart  = 2               ; start at color 17
;  res@gsnSpreadColorEnd    = 14                ; end at color 200

;  res@gsnPanelLabelBar    = True   ;Turn on panel labelbar
  res@gsnStringFontHeightF = g_font

  res@gsnMaximize      = True       ; fill up the page
  res@gsnAddCyclic   = True;False
  res@gsnPaperOrientation = "portrait"
  res@gsnContourZeroLineThicknessF = 2.  ;set thickness of zero


  res@lbLabelBarOn = False   ; turn off the label bar
  res@lbOrientation          = "horizontal"
  res@lbLabelFontHeightF  = g_font              ; make labels smaller
  ;res@lbLabelStride = 1

  res@mpFillOn   = False     ; turn off gray continents
  res@mpGeophysicalLineThicknessF = 2
  res@mpGeophysicalLineColor      = "black";"white" 
  res@mpFillDrawOrder="PostDraw"
  res@mpCenterLonF = 180.
  res@mpMaxLatF  = g_figlatN
  res@mpMinLatF  = g_figlatS
  res@mpMaxLonF  = g_figlonW
  res@mpMinLonF  = g_figlonE

  res@tmYLMajorLengthF=0.01
  res@tmXBMajorLengthF=0.01
  res@tmYROn = False
  res@tmXTOn = False
  res@tmYLTickSpacingF=10
  res@tmYLMinorOn = False
  res@tmXBMinorOn = False
  res@tmXBLabelFontHeightF = g_font
  res@tmYLLabelFontHeightF = g_font

  res4                  = True       ; use plot options
  res4@cnFillOn         = True       ; Fill contours
  res4@cnLinesOn        = False;True      ; turn off contour lines
  res4@gsnFrame         = False
  res4@gsnDraw  = False
  res4@gsnLeftString   = " "                   
  res4@gsnRightString  = " "                 
  res4@gsnCenterString = " "
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
  res4@lbLabelBarOn =False
  plot1 = gsn_csm_contour_map_ce(wks,pr12_3,res)
  plot2 = gsn_csm_contour(wks,sig,res4)
  polyres                   = True
  polyres@gsMarkerIndex     = 2          ; polymarker style
  polyres@gsMarkerSizeF     = 16.          ; polymarker size
  polyres@gsMarkerThicknessF     = 6.          ; polymarker size
  polyres@gsMarkerColor     = "green"          ; polymarker size
  plot1@$unique_string("fxxk ncl")$    = gsn_add_polymarker(wks,plot1,115,0,polyres)
  overlay(plot1,plot2)
  draw(plot1)
  frame(wks)
  delete(var1)
;end do
system("rm -rf pr12_3.nc")
fout = addfile("pr12_3.nc","c")
fout->pr12_3=pr12_3
end 
