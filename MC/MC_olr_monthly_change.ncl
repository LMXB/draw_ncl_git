begin
lon_array = 140.0
lat_array = -5.0
range = 5.0

in_file1="/home/ys17-19/cjx/observation_data/olr.mon.mean.nc"
fin_var1 = addfile(in_file1,"r")
var1 = short2flt(fin_var1->olr(0:479:1,:,:))
printVarSummary(var1)

var_mon = new((/12,dimsizes(var1(0,:,0)),dimsizes(var1(0,0,:))/),float, "No_FillValue")

do i=0,11,1
    var_mon(i,:,:)= dim_avg_n_Wrap(var1(i:479:12,:,:),0)
end do
copy_VarCoords(var1(0:11, :, :), var_mon)
printVarSummary(var_mon)
delete(var1)

var_tropical = wgt_areaave(var_mon(:,{lat_array-range:lat_array+range},{lon_array-range:lon_array+range}), 1.0, 1.0, 0)
print(var_tropical)
end 
