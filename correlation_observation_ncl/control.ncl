begin
    lon_array=(/10.0, 115.0, 140.0, 155.0, 231.0,  284.0, 310.0/)
    lat_array=(/0.0,  0.0,   -5.0,  5.0,   5.0,    0.0,   0.0/)
    do i=0,6,1
        print(lon_array(i))
        load "correlation_precip.ncl"
    end do
end
