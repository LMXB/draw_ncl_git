begin

l_thick = 2
g_font = 0.025
RefMF = 0.15
FillValue = 0
res                 = True  
res@gsnDraw         = False
res@gsnFrame        = False
res@tmXBTickSpacingF =60
res@tmYLTickSpacingF =30
res@lbLabelFontHeightF = g_font
res@mpCenterLonF = 180.
;res@cnLineLabelsOn   = False      ; turn off contour line labels
res@gsnMaximize      = True       ; fill up the page
res@gsnLeftString   = " "                   
res@gsnRightString  = " "                 
;res@gsnCenterString  = " "                 
res@gsnCenterStringFontHeightF = g_font  
res@tiMainOn               = False
res@mpFillOn               = False
res@mpGeophysicalLineThicknessF = l_thick
res@mpGridLineThicknessF   = l_thick
res@tmXBLabelFontHeightF = g_font
res@tmYLLabelFontHeightF = g_font
res@vcGlyphStyle         = "FillArrow" ;  "CurlyVector" , "WindBarb"   
;res@mpGridSpacingF         = 10.     ;
;res@pmTickMarkDisplayMode = "Always"
;; 箭头头部大小一致。若要绘制头部大小不一致箭头可参考第4章示例。

res@vcFillArrowEdgeColor     = "grey"
res@vcFillArrowFillColor     = "grey"
res@vcGlyphOpacityF          = 1.0
res@vcFillArrowMinFracWidthF = 0.3 
res@vcFillArrowHeadMinFracXF = 0.3  
res@vcFillArrowHeadMinFracYF = 0.3 
;; 参考箭头
res@vcRefAnnoOn               = False;True  
res@vcRefMagnitudeF           = RefMF      ;标准长度箭头所表示的大小
res@vcRefLengthF              = 0.05  ;标准长度箭头在图形中的长度
res@vcRefAnnoBackgroundColor  = "white" ;背景颜色     
res@vcRefAnnoPerimOn          = False   ;关闭边框   
res@vcRefAnnoFontHeightF      = 0.014   ;参考箭头标签字体大小      
res@vcRefAnnoString1On        = False   ;设定参考箭头上、        
res@vcRefAnnoString2On        = True    ;        下的字符
res@vcRefAnnoString2          = RefMF + " m/s" 
res@vcRefAnnoOrthogonalPosF   = 0.155
res@vcRefAnnoArrowUseVecColor = False
res@vcRefAnnoArrowEdgeColor   ="black"
res@vcRefAnnoArrowFillColor   ="black"
res@vcMinDistanceF            = 0.02
;res@mpMaxLatF=g_figlatN
;res@mpMinLatF=g_figlatS
;res@mpMaxLonF=g_figlonW
;res@mpMinLonF=g_figlonE

res4                 = True  
res4@gsnDraw         = False
res4@gsnFrame        = False
res4@lbLabelFontHeightF = g_font
res4@gsnMaximize      = True       ; fill up the page
res4@gsnLeftString   = " "                   
res4@gsnRightString  = " "                 
res4@gsnCenterString = " " 
res4@tmYLLabelFontHeightF = g_font
res4@vcGlyphStyle         = "FillArrow" ;  "CurlyVector" , "WindBarb"   
;res4@mpGridSpacingF         = 10.     ;
;re4s@pmTickMarkDisplayMode = "Always"
;; 4箭头头部大小一致。若要绘制头部大小不一致箭头可参考第4章示例。
res4@vcFillArrowEdgeColor     = "black"
res4@vcFillArrowFillColor     = "black"
res4@vcFillArrowMinFracWidthF = 0.3 
res4@vcFillArrowHeadMinFracXF = 0.3  
res4@vcFillArrowHeadMinFracYF = 0.3 
;; 4参考箭头
res4@vcRefAnnoOn               = True  
res4@vcRefMagnitudeF           = RefMF      ;标准长度箭头所表示的大小
res4@vcRefLengthF              = 0.05  ;标准长度箭头在图形中的长度
res4@vcRefAnnoBackgroundColor  = "white" ;背景颜色     
res4@vcRefAnnoPerimOn          = False   ;关闭边框   
res4@vcRefAnnoFontHeightF      = 0.014   ;参考箭头标签字体大小      
res4@vcRefAnnoString1On        = False   ;设定参考箭头上、        
res4@vcRefAnnoString2On        = True    ;        下的字符
res4@vcRefAnnoString2          = RefMF + " m/s" 
res4@vcRefAnnoOrthogonalPosF   = 0.155
res4@vcMinDistanceF            = 0.02
res4@vcRefAnnoArrowEdgeColor   ="black"
res4@vcRefAnnoArrowFillColor   ="black"

polyres                   = True
polyres@gsMarkerIndex     = 2          ; polymarker style
polyres@gsMarkerSizeF     = 16.          ; polymarker size
polyres@gsMarkerThicknessF     = 6.          ; polymarker size
polyres@gsMarkerColor     = "green"          ; polymarker size

lon_array = (/10.0, 115.0, 140.0, 155.0, 231.0,  284.0, 310.0/)
lat_array = (/0.0,  0.0,   -5.0,  5.0,   5.0,    0.0,   0.0/)
range = 5.
level = (/200, 500, 850/)
siglvl = 0.05

do i = 1, 1, 1
    in_olr="/home/ys17-19/cjx/all_output_data/PCOR/smooth_daily/olr_MAM_1979_2016.nc"
    fin_var1 = addfile(in_olr,"r")
    olr_in = fin_var1->olr_smooth(:,:,:)
    pre_olr =olr_in(time|:,{lat | lat_array(i)-range:lat_array(i)+range},{lon | lon_array(i)-range:lon_array(i)+range})
    olr = wgt_areaave(pre_olr,1.0,1.0,0)
    ;printVarSummary(olr)
   
    do j=0, 2, 1
        outfile="/home/ys17-19/cjx/figure/regression-observation/olr_wind" + level(j)
        in_file="/home/ys17-19/cjx/all_output_data/PCOR/smooth_daily/uwnd_MAM_1979_2016.nc"
        fin_var = addfile(in_file,"r")
        uwnd = fin_var->var_smooth(:,{level(j)},:,:)
        in_file="/home/ys17-19/cjx/all_output_data/PCOR/smooth_daily/vwnd_MAM_1979_2016.nc"
        fin_var = addfile(in_file,"r")
        vwnd = fin_var->var_smooth(:,{level(j)},:,:)


        ;rc_uwnd=(/regCoef_n(olr,uwnd,0,0)/)
        rc_uwnd=regCoef_n(olr,uwnd,0,0)
        df_uwnd = rc_uwnd@nptxy-2
        tval_uwnd = rc_uwnd@tval
        prob_uwnd_temp = student_t(tval_uwnd,df_uwnd)
        copy_VarCoords(uwnd(0,:,:),rc_uwnd)
        rc_uwnd@FillValue = FillValue
        prob_uwnd = onedtond(prob_uwnd_temp, (/121, 240/)) 
        copy_VarCoords(uwnd(0,:,:),prob_uwnd)


        rc_vwnd=regCoef_n(olr,vwnd,0,0)
        df_vwnd = rc_vwnd@nptxy-2
        tval_vwnd = rc_vwnd@tval
        prob_vwnd_temp = student_t(tval_vwnd,df_vwnd)
        copy_VarCoords(vwnd(0,:,:),rc_vwnd)
        rc_vwnd@FillValue = FillValue
        prob_vwnd = onedtond(prob_vwnd_temp, (/121, 240/)) 
        copy_VarCoords(vwnd(0,:,:),prob_vwnd)
        ;printVarSummary(prob_uwnd)

        uwnd_sig=uwnd(0,:,:)
        uwnd_unsig=uwnd(0,:,:)
        uwnd_sig=where(prob_uwnd .le.siglvl .or. prob_vwnd .le.siglvl, rc_uwnd, rc_uwnd@FillValue)
        uwnd_unsig=where(prob_uwnd .ge.siglvl .and. prob_vwnd .ge.siglvl, rc_uwnd, rc_uwnd@FillValue)

        vwnd_sig=vwnd(0,:,:)
        vwnd_unsig=vwnd(0,:,:)
        vwnd_sig=where(prob_uwnd .le.siglvl .or. prob_vwnd .le.siglvl, rc_vwnd, rc_vwnd@FillValue)
        vwnd_unsig=where(prob_uwnd .ge.siglvl .and. prob_vwnd .ge.siglvl, rc_vwnd, rc_vwnd@FillValue)
        printMinMax(uwnd_sig, 0)

        plot1 = new(1,"graphic")
        plot2 = new(1,"graphic")

        wks = gsn_open_wks("x11",outfile)
        gsn_define_colormap(wks,"GrayWhiteGray")
        res@gsnCenterString = "olr &  wind"+level(j)+" regression coefficient"
        plot1 = gsn_csm_vector_map(wks, uwnd_unsig, vwnd_unsig, res)
        plot2 = gsn_csm_vector(wks, uwnd_sig, vwnd_sig, res4)
        plot1@$unique_string("fxxk ncl")$    = gsn_add_polymarker(wks,plot1,lon_array(i),lat_array(i),polyres)
        overlay(plot1,plot2)
        draw(plot1)
        frame(wks)
   end do 
end do
;delete(r)
;delete(prob)
;delete(sig)
;delete(res)
;delete(res4)
end
