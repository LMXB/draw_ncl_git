begin

  ;;;;read SLP data   

  f     = addfile("/home/ys17-19/data-observation/ERA-interim/monthly/slp.mon.mean.nc", "r")  
  ;time = f->time
  ;yyyymm  = cd_calendar(time, -1)
  ;istrt   = ind(yyyymm .eq. g_strt_mon)
  ;ilast   = ind(yyyymm .eq. g_lst_mon)
  slp = short2flt(f->msl(::12,{0:90},:))  ;读取每年的1月，北半球数据
  
  dims = dimsizes(slp)                    ; 返回各维的大小

  year = ispan(1979,1979+dims(0)-1,1)     ; 分析的各年份
  
  ;; 计算权重  
  w  = sqrt(cos(0.01745329*slp&latitude) )     ; 权重系数                 
  wp = slp*conform(slp, w, 1)             ; wp
  copy_VarCoords(slp, wp)
  
  ;; EOF分解
  x    = wp({latitude|20:90},longitude|:,time|:)  ; 时间维放最右边
  neof = 2                             ; 保留前2模态，用于检验第1模态是否显著与其他模态相分离
  eof  = eofunc_Wrap(x, neof, False)   ; EOF分解

  ;; north 检验
  ntim = dims(0)               
  sig_pcv = eofunc_north(eof@pcvar, ntim, False)
    
  ;; 计算PC，并标准化
  eof_ts = eofunc_ts_Wrap (x, eof, False)
  eof_ts = dim_standardize_n(eof_ts,1,1)
  eof_ts!1 = "year"
  eof_ts&year = ispan(1979, 2017, 1)
  print(eof_ts(0,:))
  
  ;path_out = "/home/ys17-19/cjx/all_output_data/AOI/AOI.nc"
  ;system("rm -f " + path_out)
  ;f_out = addfile(path_out,"c")
  ;f_out->AOI = eof_ts(0,:)
end
