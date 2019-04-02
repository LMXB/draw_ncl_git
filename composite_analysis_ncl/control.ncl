begin
    ;define parameter
    case_name_list=(/"HEAT_MC","HEAT_SA"/)
    ;lon_array=(/10.0, 115.0, 140.0, 155.0, 231.0,  284.0, 310.0/)
    ;lat_array=(/0.0,  0.0,   -5.0,  5.0,   5.0,    0.0,   0.0/)
    lon_array=(/140.0, 310.0/)
    lat_array=(/-5.0,  0.0 /)

    lat_N=70
    lat_S=-70
    lon_E=90
    lon_W=280
    g_font = 0.025    
    l_thick= 2

    do j=0,0,1
        case_name=case_name_list(j)
        print(case_name)
        ;load "global_height_ttest.ncl"
        ;load "global_psl_ttest.ncl"
        ;load "global_ts_ttest.ncl"
        ;load "global_precc_ttest.ncl"
        load "global_temp_ttest.ncl"
        ;load "global_wind_ttest.ncl"
    end do
end
