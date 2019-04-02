l_thick= 2
g_font = 0.025
    lon_array=(/10.0, 115.0, 140.0, 155.0, 231.0,  284.0, 310.0/)
    lat_array=(/0.0,  0.0,   -5.0,  5.0,   5.0,    0.0,   0.0/)
    mxlag=4
begin
dim=dim_num(lon_array)
;print(dim)
do i=0,dim-1,1
in_file="/home/ys17-19/cjx/GPCP/gpcp_v02r03_monthly_197901_201901.nc"
fin_var = addfile(in_file,"r")
var = fin_var->precip(0:479:1,:,:)
;printVarSummary(var)
var_ssn = month_to_season(short2flt(var),"MAM")
;var_ssn = month_to_season(var,"MAM")
;printVarSummary(var_ssn)
var_matrix=var_ssn(:,0:dim-1:1,0)
var_matrix(:,i)=(/var_ssn({latitude | lat_array(i)},{longitude | lon_array(i)},time|:)/)
end do

var_matrix!0="time"
var_matrix!1="location"
var_matrix&time=fspan(1979,2018,40)
var_matrix&location=lon_array
printVarSummary(var_matrix)
r=new((/mxlag+1,dim,dim/),float,"No_FillValue")
;print(var_matrix(i,:))
var1_matrix=var_matrix(location|:,time|:)
;printVarSummary(var1_matrix)

do i=0,dim-1,1
    do j=0,dim-1,1
    r(:,i,j)=esccr(var1_matrix(i,:),var1_matrix(j,:),mxlag)
    end do
end do
printVarSummary(r)

do i=0,mxlag,1
opt=True
opt@fout ="/home/ys17-19/cjx/draw_ncl/con_heat_center/precc_esccr_"+i+".txt"
write_matrix(r(i,:,:),"7f15.7",opt)
end do
end
