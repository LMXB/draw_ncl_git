
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin


;================================================
;Variables List:
;	sst--------------TS
;================================================
;global variables
  ;Define parameters
    g_data_path = "/home/ys17-19/cjx/observation_data/sst/HadISST_monthly_197901_201812.nc"
    g_strt_mon = 197901 
    g_lst_mon = 201812
    
    ;western indian ocean
    western_latS = -10.
    western_latN = 10.
    western_lonW = 50.
    western_lonE = 70.

    ;eastern indian ocean
    eastern_latS = -10.
    eastern_latN = 0.
    eastern_lonW = 90.
    eastern_lonE = 110.

;*************************For F_Compset Ctrl***********************************

; ==============================================================
; Mission 1. Open the file: Read only the user specified period
; ==============================================================

	ctrl_file1   = g_data_path
	ctrl_in1     = addfile (ctrl_file1, "r")   ; note the "s" of addfile
	time_hist    = ctrl_in1->time
    yyyymm  = cd_calendar(time_hist,-1)
    istrt   = ind(yyyymm .eq. g_strt_mon)
    ilast   = ind(yyyymm .eq. g_lst_mon)
	sst  = rmMonAnnCycTLL(ctrl_in1->sst(istrt:ilast,:,:))			; p for unify the var name

;-----pre-proccess for sst---------------------------------------------------
    ;sst_temp = sst
    ;sst(:,:,{-179.5:-0.5}) = (/sst(:,:,{0.5:179.5})/)
    ;sst(:,:,{0.5:179.5}) = (/sst_temp(:,:,{-179.5:-0.5})/)
    ;delete(sst_temp)
    ;sst&longitude = fspan(0.5,359.5,360)
    sst_ano = sst
    ;sst_ano = month_to_season(sst,"MAM")
    ;sst_ano = dim_rmvmean_n_Wrap(sst_ssn, 0)
    printVarSummary(sst_ano)

    ;lat   = ctrl_in1->latitude
    ;lon   = ctrl_in1->longitude
    ;
    ;jlat  = dimsizes( lat )
    ;
    ;rad    = 4.0*atan(1.0)/180.0
    ;re     = 6371220.0
    ;rr     = re*rad
    ;
    ;dlon   = abs(lon(2)-lon(1))*rr
    ;dx     = dlon*cos(lat*rad);                                     lat can have variable spacing
    ;dy     = new ( jlat, typeof(dx)); close enough
    ;dy(0)  = abs(lat(2)-lat(1))*rr
    ;dy(1:jlat-2)  = abs(lat(2:jlat-1)-lat(0:jlat-3))*rr*0.5   
    ;dy(jlat-1)    = abs(lat(jlat-1)-lat(jlat-2))*rr
    ;
    ;area   = dx*dy                                ; cell area function of latitude only

    west_ano = wgt_areaave_Wrap(sst_ano(:,{western_latS:western_latN},{western_lonW:western_lonE}), 1.0, 1.0, 0)
    east_ano = wgt_areaave_Wrap(sst_ano(:,{eastern_latS:eastern_latN},{eastern_lonW:eastern_lonE}), 1.0, 1.0, 0)
    ido_index = west_ano - east_ano
    print(ido_index)
    
;    sst_djf = month_to_season(sst,"MAM")
;
;
;;-----count ido_index---------------------------------------------------
;    west_ave = wgt_areaave_Wrap(sst_djf(:,{western_latS:western_latN},{western_lonW:western_lonE}), 1.0, 1.0, 0)
;    east_ave = wgt_areaave_Wrap(sst_djf(:,{eastern_latS:eastern_latN},{eastern_lonW:eastern_lonE}), 1.0, 1.0, 0)
;    ido_index = west_ave - east_ave
;    printVarSummary(ido_index)
;
;    system("rm -rf ido_index.nc")
;    f = addfile("ido_index.nc","c")
;    f->ido_index = ido_index
;    print(ido_index)
    end
