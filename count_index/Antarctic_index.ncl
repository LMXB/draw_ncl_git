begin

  ;;;;read SLP data   
  g_strt_mon = 197901
  g_lst_mon = 201612

  f     = addfile("/home/ys17-19/data-observation/ERA-interim/monthly/slp.mon.mean.nc", "r")  
  time = f->time
  yyyymm  = cd_calendar(time, -1)
  istrt   = ind(yyyymm .eq. g_strt_mon)
  ilast   = ind(yyyymm .eq. g_lst_mon)
  slp = short2flt(f->msl(istrt:ilast,:,:))  

  clm = clmMonTLL (slp) ; monthly climatology
  slpAnom = calcMonAnomTLL (slp,clm)
  slpStd  = stdMonTLL(slp)
  printVarSummary(slpStd)
  printVarSummary(slpAnom)
  slpNor = slpAnom

  do i = 0, 455, 1
    mon = mod(i, 12) 
    slpNor(i,:,:) = slpAnom(i,:,:)/slpStd(mon,:,:)
  end do

  printVarSummary(slpNor)
  slp40S = dim_avg_n_Wrap(slpNor(:,{-40},:), 1)
  slp65S = dim_avg_n_Wrap(slpNor(:,{-65},:), 1)
  AI = slp40S - slp65S
  copy_VarCoords(slp(:,0,0),AI)
  printVarSummary(AI)
  print(AI)
  
  ;wks = gsn_open_wks("x11", "./")
  ;date = cd_calendar(AI&time,  1)
  ;plot = gsn_csm_xy(wks, date, AI, False)

  ;path_out = "/home/ys17-19/cjx/all_output_data/AI/AI.nc"
  ;system("rm -f " + path_out)
  ;f_out = addfile(path_out,"c")
  ;f_out->AI = AI
end
