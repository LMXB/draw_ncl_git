begin
fils = systemfunc("ls /home/ys17-19/cjx/GPCP/gpcp_v02r03*.nc") 
;print(fils)
setfileoption("nc","SuppressClose",False)
f = addfiles(fils,"r")
ListSetType(f,"cat")

precip = f[:]->precip
printVarSummary(precip)


system("rm -rf /home/ys17-19/cjx/GPCP/gpcp_v02r03_monthly_197901_201901.nc")
fout = addfile("/home/ys17-19/cjx/GPCP/gpcp_v02r03_monthly_197901_201901.nc","c")
;fileattdef(fout,"time", -1, True)
fout->precip=precip 
end 










