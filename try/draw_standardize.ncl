 begin
 
;;;;
;;; read data from grib file
;;;;
 
   grib_file="/home/ys17-19/data-model/CESM_CTRL/F2000_F19_CAM4_CTRL/pro/CTRL.cam.h0.PRECC.1-110.nc"
   outfile="./standardize_precc"
    fin = addfile(grib_file,"r")    
 
 
;;; get variables: temperature, longitude, latitude
 
    var = fin->PRECC
    lon = fin->lon
    lat = fin->lat
    var1 = var
    var1 = var * 1000 * 86400
;;;;
;;; prepare
;;;;
 

 
 
;;;;
;;; create plot (png)
;;;;
 
 
    wks = gsn_open_wks("png",outfile)                 ; open wk station
    gsn_define_colormap(wks,"precip2_17lev")  ; load color table
    
 
 
;;; Font Style
    res1 = True	                                  ; plots modification on
    res1@gsnMaximize = True
    res1@txFont = "Helvetica"
    res1@txFontQuality = "High"
 
 
;;; Title
;    res1@tiMainString    = "201809061800"   ; add title
;    res1@gsnLeftString   = ""
;    res1@gsnRightString  = ""
 
 
;;; Map
 
 
;;; T2m
 
    res1@cnFillOn              = True             ; turn on color fill	
    res1@cnLinesOn             = False            ; turn of contour lines
    
    res1@gsnSpreadColorStart = -1
    res1@gsnSpreadColorEnd = 2
 
  
;;; Map Projection (min and max Lon and Lat)
    res1@mpMinLatF            = -20
    res1@mpMaxLatF            = 20
    res1@mpMinLonF            = 95
    res1@mpMaxLonF            = 135 
    res1@mpLimitMode="LatLon"

var1_ssn = month_to_season(var1,"MAM")
pre=dim_stddev_n_Wrap(var1_ssn,0)
plot = gsn_csm_contour_map(wks,pre,res1)     ; create plot
 
end
