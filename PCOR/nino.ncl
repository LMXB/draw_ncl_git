
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
    ;g_latS=-5.
    ;g_latN=5.
    ;g_lonW=190.
    ;g_lonE=240.

    
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
    g_font = 0.018

    ;Nino 3
    g_latS=-5.
    g_latN=5.
    g_lonW=210.
    g_lonE=270.
    g_strt_mon = 197901;197912;197901 
    g_lst_mon = 201812;201611;201812
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

    system("rm -rf nino3.nc")
    f = addfile("nino3.nc","c")
    f->nino3 = nino3

    ;f=addfile("/home/ys17-19/cjx/draw_ncl/sample_ncl/script-upload/data/ENSO-index.nc","r")
    ;nino=f->ensoi
    ;;nino= asciiread("nino.txt",-1,"float")
    ;;;printVarSummary(nino)
    ;print(nino)
    ;r= escorc(nino,nino3(:34))
    ;print(r)
    end
