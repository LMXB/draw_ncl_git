f=addfile("./pr12_3.nc","r")
pr_new= f->pr12_3
load "redraw_Yuan_2012.ncl"
pr_old=pr12_3(3,:,:)

;load "PCOR_copy.ncl"
;pr_new=pr12_3
;load "../z_olr.ncl"
;pr_old=pr12_3
pr=pr_new-pr_old
pr_print=where(pr .ne. 0, pr, pr@_FillValue)
asciiwrite ("test.txt",pr_print)
