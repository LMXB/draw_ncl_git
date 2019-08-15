begin
;-------------------------------definite the location of the hato center------------------------------------------------------
case_num = 4
time_num = 17
center_lat = new((/time_num, case_num/),float,"No_FillValue")
center_lon = new((/time_num, case_num/),float,"No_FillValue")
center_lat(:,0) = (/23.83531, 20.02506, 20.13479, 20.37227, 20.09822, 19.91526, 19.64041,\
19.51199, 19.54869, 19.53034, 19.2916, 19.19968, 19.1629,19.27322, 19.54869, 19.62208, 19.80538/)  
center_lon(:,0) = (/120.9722, 122.1989, 121.4979, 120.0765, 119.5702, 118.8108, 117.701, 117.1363,\
116.1238, 115.1307, 114.4687, 113.5925, 112.9694, 112.3269, 111.6648, 111.0807, 110.2239/)
center_lat(:,1) = (/23.83531, 20.20789, 20.86431, 20.84612, 21.0825, 20.82792, 21.04615, \
21.39103, 21.57222, 22.00614, 22.42075, 23.03137, 23.65708, 24.45718, 24.97012, 25.5161, 25.5161/)
center_lon(:,1) = (/120.9722, 122.3157, 121.7705, 121.1279, 120.2907, 119.9207, 119.4923, 119.0445, \
118.6551, 118.0709, 117.7399, 117.2142, 116.7079, 115.9875, 115.306, 114.644, 113.8846/)
center_lat(:,2) = (/23.83531, 19.95187, 20.24444, 19.95187, 19.2916, 18.97888, 18.90521, \
18.79465, 18.37016, 17.90756, 17.55518, 17.49947, 17.4066, 17.51804, 17.51804, 17.05325, 16.79246/)
center_lon(:,2) = (/120.9722, 122.1599, 121.42, 120.096, 119.2003, 118.1293, 117.1752, 116.0264, \
115.0139, 114.1766, 113.3588, 112.7747, 111.9374 ,111.2949 ,110.2434 ,109.3672 ,108.7052/)
center_lat(:,3) = (/23.83531, 20.33575, 20.7369, 21.04615, 20.82792, 21.0098, 20.88251, \
20.93707, 20.97344, 21.0825, 20.99162, 21.31849, 21.55411, 21.95197, 22.29469, 22.15049, 22.5287/)
center_lon(:,3) = (/120.9722, 122.3546, 122.0626, 121.5174, 120.6606, 119.7649, 118.733, 118.032, \
117.37, 116.7858, 116.2406, 115.5396, 114.4882, 113.8651, 113.0862, 112.2684, 111.4896/)
	
	
U_cir_ave = new((/3,time_num/), float, "No_FillValue")
V_cir_ave = new((/3,time_num/), float, "No_FillValue")
large_radius = 4.0
small_radius = 2.5
	
;-------------------------------read data----------------------------------------------------------------------------------

case_name = (/ "0.5sq", "1.5sq", "0sq", "2sq"/)
do j=2,case_num-1,1
	filename = "/WORK/sysu_csm_1/hato/" + case_name(j) + "/wrfout_d02_2017-08-21_12:00:00"
	input_data = addfile(filename + ".nc", "r")
	;U_in = input_data->U
	;V_in = input_data->V
	p    = wrf_user_getvar(input_data, "pressure", -1) 
	U_in = wrf_user_getvar(input_data, "ua", -1) 
	V_in = wrf_user_getvar(input_data, "va", -1)
;-------------------------------convect the data from eta coordinate to pressure coordinate-------------------------------------
	vert_coord       = "pressure"
	interp_levels = ispan(300, 900, 50)
	opts             = True
	opts@extrapolate = True 
	opts@field_type  = "pressure"
	opts@logP        = True 
	U = wrf_user_vert_interp(input_data, U_in, vert_coord, interp_levels, opts)
	U_ave = dim_avg_n_Wrap(U, 1) 
	V = wrf_user_vert_interp(input_data, V_in, vert_coord, interp_levels, opts)
	V_ave = dim_avg_n_Wrap(V, 1) 
	printVarSummary(U_ave)
	
;-------------------------------use wgt_areaave to count steer flow-----------------------------------------------------------------------------
	do it=0, time_num-1, 1
		large_south_lat = center_lat(it, j) - large_radius 
		large_north_lat = center_lat(it, j) + large_radius 
		large_west_lon  = center_lon(it, j) - large_radius 
		large_east_lon  = center_lon(it, j) + large_radius

		if(large_south_lat.lt.16.43794) then
			large_south_lat = 16.43794
		end if 
		if(large_north_lat .gt. 25.51610) then
			 large_north_lat = 25.51610  
          	end if
		if(large_west_lon .lt. 104.8304) then
			 large_west_lon = 104.8304      
          	end if
		if(large_east_lon .gt. 128.8776 ) then
			 large_east_lon = 128.8776   
          	end if
       		large_start_point = wrf_user_ll_to_ij(input_data, large_west_lon, large_south_lat, True)
       		large_end_point   = wrf_user_ll_to_ij(input_data, large_east_lon, large_north_lat, True)

		U_cir_ave(0,it) = wgt_areaave(U_ave(it, large_start_point(1)-1:large_end_point(1)-1, large_start_point(0)-1:large_end_point(0)-1), 1.0, 1.0, 0)  
		V_cir_ave(0,it) = wgt_areaave(V_ave(it, large_start_point(1)-1:large_end_point(1)-1, large_start_point(0)-1:large_end_point(0)-1), 1.0, 1.0, 0)  

		small_south_lat = center_lat(it, j) - small_radius 
		small_north_lat = center_lat(it, j) + small_radius 
		small_west_lon  = center_lon(it, j) - small_radius 
		small_east_lon  = center_lon(it, j) + small_radius

		if(small_south_lat.lt.16.43794) then
			small_south_lat = 16.43794
		end if 
		if(small_north_lat .gt. 25.51610) then
			 small_north_lat = 25.51610  
          	end if
		if(small_west_lon .lt. 104.8304) then
			 small_west_lon = 104.8304      
          	end if
		if(small_east_lon .gt. 128.8776 ) then
			 small_east_lon = 128.8776   
          	end if

       		small_start_point = wrf_user_ll_to_ij(input_data, small_west_lon, small_south_lat, True)
      	 	small_end_point   = wrf_user_ll_to_ij(input_data, small_east_lon, small_north_lat, True)
		U_cir_ave(1,it) = wgt_areaave(U_ave(it, small_start_point(1)-1:small_end_point(1)-1, small_start_point(0)-1:small_end_point(0)-1), 1.0, 1.0, 0)  
		V_cir_ave(1,it) = wgt_areaave(V_ave(it, small_start_point(1)-1:small_end_point(1)-1, small_start_point(0)-1:small_end_point(0)-1), 1.0, 1.0, 0)  

		U_cir_ave(2,it)	= (U_cir_ave(0,it)*16.0 - U_cir_ave(1,it)*6.25)/9.75
		V_cir_ave(2,it)	= (V_cir_ave(0,it)*16.0 - V_cir_ave(1,it)*6.25)/9.75
	end do
	printVarSummary(U_cir_ave)

;-------------------------------save the steer flow to ASCII file----------------------------------------------------------------------------------
	wind_cir_ave = new((/time_num,2/), float, "No_FillValue")
	opt=True
	opt@fout ="/WORK/sysu_csm_1/chenjx/draw_ncl/rectangle_"+case_name(j)+"_steer_flow.txt"

	do it=0, time_num-1, 1
		wind_cir_ave(it,0) = U_cir_ave(2,it)
		wind_cir_ave(it,1) = V_cir_ave(2,it)
	end do
	system("rm -f /WORK/sysu_csm_1/chenjx/draw_ncl/rectangle_"+case_name(j)+"_steer_flow.txt")
	write_matrix(wind_cir_ave(:,:),"2f15.7",opt)
end do
end
