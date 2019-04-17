begin
    ;define parameter
    case_name_list=(/"HEAT_EMC","HEAT_MC","HEAT_SA"/)
    lon_array=(/115, 140.0, 310.0/)
    lat_array=(/0, -5.0,  0.0 /)

    lat_N=90
    lat_S=-90
    lon_E=0
    lon_W=360
    g_font = 0.025    
    l_thick= 2

    CTRL_file="/home/ys17-19/cjx/all_output_data/B2000_CTRL_output/B2000_f19g16_CP_CTRL.cam.h0.250-289.nc"
    GW_file="/home/ys17-19/cjx/CTRL_data/B2000_raw_data/B2000_f19g16_CP_CTRL.cam.h0.0252-02.nc"
    do j=0,0,1
        case_name=case_name_list(j)
        print(case_name)
        ;load "polar_height_ttest.ncl"
        load "SH_polar_height_ttest.ncl"
       ; load "polar_ts_ttest.ncl"
    end do
end
