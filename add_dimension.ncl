begin

f1 = addfile("Mangkhut_sfc_6h_20180906-20180918.nc","r")
sp = f1[:]->sp
printVarSummary(sp)

f2 = addfile("Mangkhut_air_u_6h_20180906-20180918.nc","r")
u = f2[:]->u
printVarSummary(u)

pp=u
pp=conform(u,sp,(/0,2,3/))
printVarSummary(pp)
system("rm -rf reshape_Mangkhut_sfc_6h_20180906-20180918.nc")
setfileoption("nc","Format","LargeFile") 
fout = addfile("reshape_Mangkhut_sfc_6h_20180906-20180918.nc","c")
;fileattdef(fout,"time", -1, urue)
fout->sp=pp 

end 










