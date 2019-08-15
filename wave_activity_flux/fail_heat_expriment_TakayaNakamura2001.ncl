; 3-D wave-activity flux derived by Takaya and Nakamura (1999, 2001)
; See (38) of Takaya and Nakamura (2001, JAS)
;
; Used data: 
;  Monthly-mean data of NCEP/NCAR reanalys 1
;   geopotential height (Z3: m) ; Z3.mon.mean.nc
;
;  Monthly climatology of NCEP/NCAR reanalys 1 
;   geopotential height (Z3: m) ; Z3.mon.mean.nc
;   T tempeature (T: degC)   ; T.mon.mean.nc
;   zonal wind (U: m/s)       ; U.mon.mean.nc
;   meridional wind (V: m/s)  ; V.mon.mean.nc
;
; The data are available at 
; http://www.esrl.noaa.gov/psd/data/gridded/data.ncep.reanalysis.html
;
; The period for calcuation is January, 1990 to December, 1990
; (you can modify this by changing fyear,fmon, lyear, lmon)
;
; The unit of lev_p is [hPa]
;
; Basic state: monthly climatology
;
; Perturbation: deviation from climatology
;
; Calculating the flux for each month of input data.
;
; Note that 
; (i) "p" (pressure) in Eq. (5.7) is dimensionless (pressure/1000mb)

; Output files are
; x-component:  TN2001-Fx.monthly.1990.nc
; y-component:  TN2001-Fy.monthly.1990.nc
; z-component:  TN2001-Fz.monthly.1990.nc
; QG stream function anomaly: psidev.monthly.1990.nc
; Brunt Vaisala frequency: NN.monthly.1990.nc

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin
;; The first date of calculation
;fyear = 1990
;fmon = 1
;
;; The last date of calculation
;lyear = 1990
;lmon = 12

;  direcotry + data name
diri  = "/home/ys17-19/cjx/all_output_data/HEAT_EMC_output/EMC_MAM_Z3.nc"
dirci = "/home/ys17-19/cjx/all_output_data/B2000_CTRL_output/CTRL_climatology.nc"
outfile = "/home/ys17-19/cjx/all_output_data/HEAT_EMC_output/wave_activity_flux/"

; monthly mean data
filename = systemfunc("ls "+diri)
zfile = addfile(filename,"r")

; monthly climatology data
filename = systemfunc("ls "+dirci)
btfile = addfile(filename,"r")
bzfile = addfile(filename,"r")
bufile = addfile(filename,"r")
bvfile = addfile(filename,"r")

; Test a variable's type prior to reading the variable
if (getfilevartypes(zfile,"Z3").eq."short")then
zvarorg = short2flt(zfile->Z3)
else
zvarorg = zfile->Z3
end if
zvar = zvarorg(:,:,:,:)

if (getfilevartypes(btfile,"T").eq."short")then
btvar = short2flt(btfile->T)
else
btvar = btfile->T
end if

if (getfilevartypes(bzfile,"Z3").eq."short")then
bzvar = short2flt(bzfile->Z3)
else
bzvar = bzfile->Z3
end if

if (getfilevartypes(bufile,"U").eq."short")then
buvar = short2flt(bufile->U)
else
buvar = bufile->U
end if

if (getfilevartypes(bvfile,"V").eq."short")then
bvvar = short2flt(bvfile->V)
else
bvvar = bvfile->V
end if

time = zfile->time
lat = zfile->lat
lon = zfile->lon
lev_p = zfile->lev_p

ntime = dimsizes(time)
nlat = dimsizes(lat)
nlon = dimsizes(lon)
nlev_p = dimsizes(lev_p)

czvar = new((/nlev_p,nlat,nlon/),float,zvarorg@_FillValue)
ctvar = new((/nlev_p,nlat,nlon/),float,zvarorg@_FillValue)
cuvar = new((/nlev_p,nlat,nlon/),float,zvarorg@_FillValue)
cvvar = new((/nlev_p,nlat,nlon/),float,zvarorg@_FillValue)

czvar@_FillValue = zvarorg@_FillValue
ctvar@_FillValue = zvarorg@_FillValue
cuvar@_FillValue = zvarorg@_FillValue
cvvar@_FillValue = zvarorg@_FillValue

czvar(:,:,:) = bzvar(:,:,:)
ctvar(:,:,:) = btvar(:,:,:)
cuvar(:,:,:) = buvar(:,:,:)
cvvar(:,:,:) = bvvar(:,:,:)

;  Gas constant
gc=290
;  Gravitational acceleration
ga=9.80665

;  Radius of the earth
re=6378388

; scale height
sclZ3=8000.

; pi
pi = atan(1.0)*4.

; Coriolis parameter
f =  2.*2.*pi/(60.*60.*24.)*sin(pi/180. * lat(:))
f!0 = "lat"
f&lat = lat
f@_FillValue = zvarorg@_FillValue

; missing for 10S - 10N
do ilat = 0, nlat-1
if (abs(lat(ilat) ).lt. 10. ) then
f(ilat)= f@_FillValue
end if
end do

; cosine
coslat = cos(lat(:)*pi/180.)

; 1-D -> 4-D
lev_ptmp = conform_dims(dimsizes(bzvar),lev_p,0)
coslattmp = conform_dims(dimsizes(bzvar),coslat,1)
ftmp = conform_dims(dimsizes(bzvar),f,1)

; vertical gradient of potential temperature  (K/m)
dthetadz = center_finite_diff_n(ctvar*(1000./lev_ptmp)^0.286,-sclZ3*log(lev_p/1000),False,0,1)

; Brunt Vaisala frequency
NN = (gc*(lev_ptmp/1000.)^0.286)/sclZ3 * dthetadz
NN@_FillValue = ctvar@_FillValue
NN = where(NN .gt. 0, NN, NN@_FillValue)

; magnitude of climatological wind
cumag = sqrt(cuvar^2 + cvvar^2)
cumag@_FillValue = cuvar@_FillValue
cumag = where(cumag .gt. 0, cumag, cumag@_FillValue)

;height anomaly
do nt = 0, ntime-1, 1
zavar = zvar(nt,:,:,:) - czvar

; QG steam function for anomaly
psidev(nt,:,:,:) = zavar*ga /ftmp

;dpsidev/dlon
dpsidevdlon =  center_finite_diff_n(psidev(nt,:,:,:),lon*pi/180.,True,0,3)

;ddpsidev/dlonlon
ddpsidevdlonlon =  center_finite_diff_n(dpsidevdlon,lon*pi/180.,True,0,3)

;dpsidev/dlat
dpsidevdlat = center_finite_diff_n(psidev(nt,:,:,:), lat*pi/180., False,0,2)

;ddpsidev/dlonlat
ddpsidevdlonlat =  center_finite_diff_n(dpsidevdlon,lat*pi/180.,False,0,2)

;ddpsidev/dlatdlat
ddpsidevdlatlat = center_finite_diff_n(dpsidevdlat, lat*pi/180.,False,0,2)

;dpsidev/dz
dpsidevdz = center_finite_diff_n(psidev(nt,:,:,:), -sclZ3*log(lev_p/1000),False,0,1)

;ddpsidev/dlondz
ddpsidevdlonz = center_finite_diff_n(dpsidevdlon, -sclZ3*log(lev_p/1000),False,0,1)

;ddpsidev/dlatdz
ddpsidevdlatz = center_finite_diff_n(dpsidevdlat, -sclZ3*log(lev_p/1000),False,0,1)

xuterm = (dpsidevdlon*dpsidevdlon - psidev(nt,:,:,:)*ddpsidevdlonlon)
xvterm = (dpsidevdlon*dpsidevdlat - psidev(nt,:,:,:)*ddpsidevdlonlat)
;yuterm = xvterm
yvterm = (dpsidevdlat*dpsidevdlat - psidev(nt,:,:,:)*ddpsidevdlatlat)

zuterm = (dpsidevdlon*dpsidevdz - psidev(nt,:,:,:)*ddpsidevdlonz)
zvterm = (dpsidevdlat*dpsidevdz - psidev(nt,:,:,:)*ddpsidevdlatz)

; Mask out where westerlies is small or negative (less than 5 m/s).
;  by using mask

;x-component of (38)
Fx(nt,:,:,:) = mask( lev_ptmp/1000./(2.*cumag*re*re)*( cuvar/coslattmp * xuterm + cvvar * xvterm), cuvar.lt.5,False)

;y-component 
Fy(nt,:,:,:) = mask(lev_ptmp/1000./(2.*cumag*re*re)*( cuvar*xvterm + coslattmp*cvvar*yvterm),  cuvar.lt.5,False)

;z-component 
Fz(nt,:,:,:) = mask(lev_ptmp/1000.*ftmp*ftmp/(2.*cumag*NN*re)*(cuvar*zuterm + coslattmp*cvvar*zvterm), cuvar.lt.5, False)

;Fx =  lev_ptmp/1000./(2.*cumag*re*re)*( cuvar/coslattmp * xuterm + cvvar * xvterm)
;Fy = lev_ptmp/1000./(2.*cumag*re*re)*( cuvar*xvterm + coslattmp*cvvar*yvterm)
;Fz = lev_ptmp/1000.*ftmp*ftmp/(2.*cumag*NN*re)*(cuvar*zuterm + coslattmp*cvvar*zvterm)
end do
print(Fx)

; for output
Fx!0 = "time"
Fx&time = time
Fx!1 = "lev_p"
Fx&lev_p = lev_p
Fx!2 = "lat"
Fx&lat = lat
Fx!3 = "lon"
Fx&lon = lon

Fy!0 = "time"
Fy&time = time
Fy!1 = "lev_p"
Fy&lev_p = lev_p
Fy!2 = "lat"
Fy&lat = lat
Fy!3 = "lon"
Fy&lon = lon

Fz!0 = "time"
Fz&time = time
Fz!1 = "lev_p"
Fz&lev_p = lev_p
Fz!2 = "lat"
Fz&lat = lat
Fz!3 = "lon"
Fz&lon = lon

psidev!0 = "time"
psidev&time = time
psidev!1 = "lev_p"
psidev&lev_p = lev_p
psidev!2 = "lat"
psidev&lat = lat
psidev!3 = "lon"
psidev&lon = lon

NN!0 = "time"
NN&time = time
NN!1 = "lev_p"
NN&lev_p = lev_p
NN!2 = "lat"
NN&lat = lat
NN!3 = "lon"
NN&lon = lon

Fx@units = "m^2/s^2"
Fx@units = "m^2/s^2"
Fz@units = "m^2/s^2"
psidev@units = "m^2/s"
NN@units = "1/s^2"

system("rm "+ outfile + "TN2001-Fx.monthly.1990.nc")
system("rm "+ outfile + "TN2001-Fy.monthly.1990.nc")
system("rm "+ outfile + "TN2001-Fz.monthly.1990.nc")
system("rm "+ outfile + "psidev.monthly.1990.nc")
system("rm "+ outfile + "NN.monthly.1990.nc")

ncFx =     addfile(outfile + "TN2001-Fx.monthly.1990.nc","c")
ncFy =     addfile(outfile + "TN2001-Fy.monthly.1990.nc","c")
ncFz =     addfile(outfile + "TN2001-Fz.monthly.1990.nc","c")
ncpsidev = addfile(outfile + "psidev.monthly.1990.nc","c")
ncNN =     addfile(outfile + "NN.monthly.1990.nc","c")

ncFx->Fx = Fx
ncFy->Fy = Fy
ncFz->Fz = Fz
ncpsidev->psidev = psidev
ncNN->NN = NN
end
