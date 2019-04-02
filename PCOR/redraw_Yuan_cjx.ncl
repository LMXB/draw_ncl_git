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

lon_array=(/10.0, 115.0, 140.0, 155.0, 231.0,  284.0, 310.0/)
lat_array=(/0.0,  0.0,   -5.0,  5.0,   5.0,    0.0,   0.0/)
range =10


;================================================
;Variables List:
;	var1--------------TS
;================================================


;global variables
    ;Define parameters
    g_data_path = "/home/ys17-19/cjx/sst/HadISST_monthly_197901_201812.nc"
    g_data_path2="/home/ys17-19/cjx/GPCP/gpcp_v02r03_monthly_197901_201901.nc"
    g_data_path3="/home/ys17-19/cjx/ERA-Interim/era_interim_moda_monthly_197901_201812.nc"

    ;Fig region
    g_figlatS=-90
    g_figlatN=90
    g_figlonE=0
    g_figlonW=360

    ;Nino 3
    g_latS=-5.
    g_latN=5.
    g_lonW=210.
    g_lonE=270.

; create an array of desired pressure levels:

        
do i=0,6,1
    g_font = 0.018
    g_season = "MAM"
    g_strt_mon = 197901 
    g_lst_mon = 201812
    g_fig_name    =   "/home/ys17-19/cjx/GPCP/PCOR/PCOR precip in area (lon="+lon_array(i)+", lat="+lat_array(i)+")&z500 -nino3"
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
	precc  =ctrl_in2->precip(istrt_prec:ilast_prec,:,:)			; p for unify the var name
   ; pre_precc =precc(time|:,{latitude | -10:10},{longitude | 105:125})
    pre_precc =precc(time|:,{latitude | lat_array(i)-range:lat_array(i)+range},{longitude | lon_array(i)-range:lon_array(i)+range})
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

    delete(var1)  
	var1  =short2flt(ctrl_in3->z(istrt_prec:ilast_prec,{500},:,:))			; p for unify the var name

    pr12_3=var1(0,:,:)
    psig = 0.05
    r23_temp=escorc(precip,nino3)
    printVarSummary(r23_temp)
    r23=pr12_3
    printVarSummary(r23)
    r23=(/r23_temp/)

    years=dimsizes(nino3)

    ; JJA SON
   ; do ii = 0, 1
        var1_ssntemp=month_to_season(var1,g_season)
        var1_ssn:=var1_ssntemp(latitude|:,longitude|:,time|:)
        var1_ssn:=var1_ssn(:,:,0:years-2)

        r12=escorc(precip(1:),var1_ssn)
        r13=escorc(nino3(1:),var1_ssn)
        pr12_3=(/(r12-r13*r23)/(sqrt(1-r13*r13)*sqrt(1-r23*r23))/)
       ; print(pr12_3)
        ; significance test
        n = years-1 
        df= n-1-2
        t=pr12_3*sqrt(df)/sqrt(1-pr12_3*pr12_3)
        p=student_t(t,df)
        sig=pr12_3
        sig=where(p .le. psig, pr12_3, pr12_3@_FillValue)
   ; end do
; ==============================================================
; Mission 3. Set plot parameters and plot
; ==============================================================

  wks = gsn_open_wks("png",g_fig_name)  ; open a ps file
;  wks = gsn_open_wks("pdf","up_T_surface_cte_mean_250-400hPa")  ; open a ps file
;  wks = gsn_open_wks("x11","diabatic_heat_250-500hPa")  ; open a ps file

;  plot = new((/5/),graphic)
;  plot_V = new((/5/),graphic)
;  plot_tp = new((/2/),graphic)
;  plot_sh = new((/2/),graphic)
;  plot_V = new((/2/),graphic)

;  gsn_define_colormap(wks,"BlAqGrYeOrReVi200") ; choose a colormap 
;   gsn_define_colormap(wks","Rainbow") ; choose a colormap
;   gsn_define_colormap(wks,"BlGrYeOrReVi200") ; choose a colormap
;  gsn_define_colormap(wks,"precip4_diff_19lev")
;  gsn_define_colormap(wks,"precip_diff_12lev")
; gsn_define_colormap(wks,"BkBlAqGrYeOrReViWh200")
; gsn_define_colormap(wks,"WhiteBlueGreenYellowRed")
 gsn_define_colormap(wks,"temp_diff_18lev")


;-----------------------------------------------------------------------------
  res                  = True       ; use plot options

  res@cnFillOn             = True               ; turn on color for contours
  res@cnLinesOn            = False              ; turn off contour lines
  res@cnLineLabelsOn       = False              ; turn off contour line labels



 ; i = NhlNewColor(wks,0.341,0.,0.533)              ; add gray to colormap
 ; j = NhlNewColor(wks,1,0.,0.)
;  res@mpLandFillColor       = "gray"            ; set land to be gray

  res@cnLevelSelectionMode = "ExplicitLevels"   ; set manual contour levels
  res@cnLevels = (/-0.45,-0.35,-0.25,-0.15,0,0.15,0.25,0.35,0.45/)
  res@cnFillColors =(/1,3,5,7,10,12,15,17,19,20/)


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


  res@lbLabelBarOn = True   ; turn off the label bar
  res@lbOrientation          = "horizontal"
  res@pmLabelBarOrthogonalPosF= 0.4
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
  res@tmYLTickSpacingF=30
  res@tmYLMinorOn = False
  res@tmXBMinorOn = False
  res@tmXBLabelFontHeightF = g_font
  res@tmYLLabelFontHeightF = g_font


    res@gsnCenterString = "PCOR precip in area (lon="+lon_array(i)+", lat="+lat_array(i)+")&Z500 -nino3"
    res@gsnLeftString = ""
    res@gsnRightString = ""
    plot1 = new(1,"graphic")
    plot2 = new(1,"graphic")
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
  overlay(plot1,plot2)
   ; plot = gsn_csm_contour_map_ce(wks,pr12_3,res) ; create a default plot
   ; plot(i) = gsn_csm_contour_map_ce(wks,pr12_3(i,:,:),res) ; create a default plot
   ; plot_V(i) = gsn_csm_vector(wks,pr12_3_u(i,:,:),pr12_3_v(i,:,:),vcres)
   ; overlay(plot(i),plot_V(i))
;end do





  ;plot_V(1) = gsn_csm_vector(wks,cp_diff_var2,cp_diff_var3,vcres)

;  plot_sh(0) = gsn_csm_contour(wks,diff_var1_sig,res4)

  ;plot_sh(1) = gsn_csm_contour(wks,cp_diff_var1_sig,res4)

  ;overlay(plot(1),plot_sh(1))

  ;overlay(plot(0),plot_V(0))
  ;overlay(plot(1),plot_V(1))
  ;pres= True 
  ;pres@gsnPanelLabelBar   = True      ;Universial colorbar
  ;pres@lbLabelFontHeightF = 0.012

  ;gsn_panel(wks,plot,(/5,1/),pres)
  draw(plot1)
  frame(wks)
  delete(var1)
end do
end 
