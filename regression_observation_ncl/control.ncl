begin
    ;define parameter
    lon_array=(/10.0, 115.0, 140.0, 155.0, 231.0,  284.0, 310.0/)
    lat_array=(/0.0,  0.0,   -5.0,  5.0,   5.0,    0.0,   0.0/)
    lat_N=70
    lat_S=-70
    lon_E=90
    lon_W=280
    g_font = 0.025    
    l_thick= 2

    do i=1,1,1
        print(lon_array(i))
        ;load "regression_precip.ncl"
        ;load "regression_precip_z500.ncl"
        ;load "regression_uwnd200.ncl"
        load "olr_wind.ncl"
        ;load "regression_wind200.ncl"
    end do
end
