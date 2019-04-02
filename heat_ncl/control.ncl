
begin
case_name_list=(/"HEAT","HEAT_F","HEAT_NA","HEAT_TEST"/)
do i=0,3,1
case_name=case_name_list(i)
;load "Antarctic_height_200_ttest.ncl"
load "Antarctic_height_500_ttest.ncl"
;load "Antarctic_height_850_ttest.ncl"
;load "Antarctic_height_925_ttest.ncl"
;load "Antarctic_psl_ttest.ncl"
;load "Antarctic_temp_500_ttest.ncl"
;load "Antarctic_temp_850_ttest.ncl"
;load "Antarctic_temp_ttest.ncl"
;load "Antarctic_wind_850_ttest.ncl"
;load "Antarctic_wind_500_ttest.ncl"
;load "Antarctic_wind_925_ttest.ncl"
end do
end
