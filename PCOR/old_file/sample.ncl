
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
    g_data_path5="/home/ys17-19/cjx/observation_data/ERA-Interim/era_interim_t.nc"

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

    g_strt_mon = 197901 
    g_lst_mon = 201812
    g_fig_name    =   "./test"

;*************************For F_Compset Ctrl***********************************

; ==============================================================
; Mission 1. Open the file: Read only the user specified period
; ==============================================================

	ctrl_file1   = g_data_path
	ctrl_file2   = g_data_path2
	ctrl_file3   = g_data_path3
	ctrl_file4   = g_data_path4
	ctrl_file5   = g_data_path5
	ctrl_in1     = addfile (ctrl_file1, "r")   ; note the "s" of addfile
	ctrl_in2     = addfile (ctrl_file2, "r")   ; note the "s" of addfile
	ctrl_in3     = addfile (ctrl_file3, "r")   ; note the "s" of addfile
	ctrl_in4     = addfile (ctrl_file4, "r")   ; note the "s" of addfile
	ctrl_in5     = addfile (ctrl_file5, "r")   ; note the "s" of addfile
	time_hist    = ctrl_in1->time
    time_uv      = ctrl_in2->time
    time_olr     = ctrl_in4->time
    time_var     = ctrl_in5->time
    yyyymm  = cd_calendar(time_hist,-1)
    yyyymm_uv=cd_calendar(time_uv,-1)
    yyyymm_olr  = cd_calendar(time_olr,-1)
    yyyymm_var  = cd_calendar(time_var,-1)
    istrt   = ind(yyyymm .eq. g_strt_mon)
    ilast   = ind(yyyymm .eq. g_lst_mon)
    istrt_uv   = ind(yyyymm_uv .eq. g_strt_mon)
    ilast_uv   = ind(yyyymm_uv .eq. g_lst_mon)
    istrt_olr   = ind(yyyymm_olr .eq. g_strt_mon)
    istrt_var   = ind(yyyymm_var .eq. g_strt_mon)
    ilast_var   = ind(yyyymm_var .eq. g_lst_mon)
    ilast_olr   = ind(yyyymm_olr .eq. g_lst_mon)
	var1  =ctrl_in1->sst(istrt:ilast,:,:)			; p for unify the var name
	var2  =ctrl_in2->uwnd(istrt_uv:ilast_uv,{850},:,:)			; p for unify the var name
	var3  =ctrl_in3->vwnd(istrt_uv:ilast_uv,{850},:,:)			; p for unify the var name
	var4  =ctrl_in4->olr(istrt_olr:ilast_olr,:,:)			; p for unify the var name
	var5  =ctrl_in5->t(istrt_var:ilast_var,{850},:,:)			; p for unify the var name

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
    var1 =short2flt(var5)
    pr12_3=var1(0,:,:)
    pr12_3_u=var2(0,:,:)
    pr12_3_v=var3(0,:,:)
    psig = 0.05

    r23_temp=escorc(olr,nino3)
    r23=pr12_3
    r23=(/r23_temp/)

    r23_uv=pr12_3_u
    r23_uv=(/r23_temp/)
    years=dimsizes(nino3)

        
        var1_ssn:=month_to_season(var1,"MAM")
        var2_ssn:=month_to_season(var2,"MAM")
        var3_ssn:=month_to_season(var3,"MAM")
        
        r12=escorc(olr,var1_ssn(latitude|:,longitude|:,time|:))
        r13=escorc(nino3,var1_ssn(latitude|:,longitude|:,time|:))
        pr12_3=(/(r12-r13*r23)/(sqrt(1-r13*r13)*sqrt(1-r23*r23))/)

        r12_u=escorc(olr,var2_ssn(lat|:,lon|:,time|:))
        r13_u=escorc(nino3,var2_ssn(lat|:,lon|:,time|:))
        pr12_3_u=(/(r12_u-r13_u*r23_uv)/(sqrt(1-r13_u*r13_u)*sqrt(1-r23_uv*r23_uv))/)
        
        r12_v=escorc(olr,var3_ssn(lat|:,lon|:,time|:))
        r13_v=escorc(nino3,var3_ssn(lat|:,lon|:,time|:))
        pr12_3_v=(/(r12_v-r13_v*r23_uv)/(sqrt(1-r13_v*r13_v)*sqrt(1-r23_uv*r23_uv))/)
        
        ; significance test
        n = years
        df= n-1-2
        t=pr12_3*sqrt(df)/sqrt(1-pr12_3*pr12_3)
        t_u=pr12_3_u*sqrt(df)/sqrt(1-pr12_3_u*pr12_3_u)
        t_v=pr12_3_v*sqrt(df)/sqrt(1-pr12_3_v*pr12_3_v)
        
        p=student_t(t,df)
        p_u=student_t(t_u,df)
        p_v=student_t(t_v,df)
        pr12_3=where(p .le. psig, pr12_3, pr12_3@_FillValue)
        pr12_3_u=where(p_u .le. psig .or. p_v .le. psig, pr12_3_u, pr12_3_u@_FillValue)

; ==============================================================
; Mission 3. Set plot parameters and plot
; ==============================================================

  wks = gsn_open_wks("png",g_fig_name)  ; open a ps file
;  wks = gsn_open_wks("pdf","up_T_surface_cte_mean_250-400hPa")  ; open a ps file
;  wks = gsn_open_wks("x11","diabatic_heat_250-500hPa")  ; open a ps file

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
  res@gsnContourZeroLineThicknessF = 2.  ;set thickness of zero


  res@lbLabelBarOn = False   ; turn off the label bar
  res@lbLabelFontHeightF  = g_font              ; make labels smaller
  ;res@lbLabelStride = 1

  res@mpFillOn   = False     ; turn off gray continents
  res@mpGeophysicalLineThicknessF = 2
  res@mpGeophysicalLineColor      = "black";"white" 
  res@mpCenterLonF = 180.
  ;res@mpMaxLatF  = g_figlatN
  ;res@mpMinLatF  = g_figlatS
  ;res@mpMaxLonF  = g_figlonW
  ;res@mpMinLonF  = g_figlonE

  res@tmYLMajorLengthF=0.01
  res@tmXBMajorLengthF=0.01
  res@tmYROn = False
  res@tmXTOn = False
  res@tmYLTickSpacingF=10
  res@tmYLMinorOn = False
  res@tmXBMinorOn = False
  res@tmXBLabelFontHeightF = g_font
  res@tmYLLabelFontHeightF = g_font

;-----------------------------------------------------------------------------
          
  vcres = True
  vcres@gsnDraw          = False           ; don't draw
  vcres@gsnFrame         = False           ; don't advance frame
  vcres@gsnRightString   = " "             ; turn off right string
  vcres@gsnLeftString    = " "             ; turn off left string
  vcres@gsnCenterString    = " "
 
  vcres@vcRefAnnoOn      = True
  vcres@vcRefAnnoOrthogonalPosF = -1.0             ; move ref vector up
  vcres@vcRefMagnitudeF         = 1.0             ; define vector ref mag
  vcres@vcRefLengthF            = 0.04            ; define length of vec ref
  vcres@vcGlyphStyle            = "LineArrow"    ; turn on curly vectors
  vcres@vcMinDistanceF          = 0.015
  vcres@vcRefAnnoString1  = "1 m/s"
  vcres@vcRefAnnoString2  = ""
  vcres@vcRefAnnoFontHeightF = 0.012
 
  vcres@vcLineArrowThicknessF     = 2.0    ;thickness of vector
;  vcres@vcLineArrowHeadMinSizeF   = 0.010
;  vcres@vcLineArrowHeadMaxSizeF   = 0.130
;--------------------------------------



    plot = gsn_csm_contour_map_ce(wks,pr12_3,res) ; create a default plot
    plot_V = gsn_csm_vector(wks,pr12_3_u,pr12_3_v,vcres)
    overlay(plot,plot_V)
    draw(plot)
    frame(wks)



  ;plot_V(1) = gsn_csm_vector(wks,cp_diff_var1,cp_diff_var2,vcres)

;  plot_sh(0) = gsn_csm_contour(wks,diff_var3_sig,res4)

  ;plot_sh(1) = gsn_csm_contour(wks,cp_diff_var3_sig,res4)

  ;overlay(plot(1),plot_sh(1))

  ;overlay(plot(0),plot_V(0))
  ;overlay(plot(1),plot_V(1))
  ;pres= True 
  ;pres@gsnPanelLabelBar   = True      ;Universial colorbar
  ;pres@lbLabelFontHeightF = 0.012

  ;gsn_panel(wks,plot,(/5,1/),pres)

end 
