## FUNCTION:
## Plot the spin injection current tensor(zxy) of Si:In sqrt3 x sqrt3  
## 7 feb 2007 at 11:41 by jl   
set term pslatex color solid aux
set output 'fig.tex'
set multiplot
set lmargin 0
#------------------33
set origin .0,-.4
set size 1.1,1.1
unset title
set ylabel '\Large $\chi$ u.a.' 0,-1
set xlabel '\Large photon energy (eV)' 0,-1
set xrange [0:10]
set yrange [0:4]
plot 'res/chi1.kk_xx_yy_zz_2168_10-nospin_8_L_0'  u 1:3 title 'Abinit 2168kp' w l 1,\
     'wien2k/sibulk/res/chi1.sm_xx_yy_zz_2168_3-nospin_7_L_0'  u 1:3 title 'wien2k 2168kp' w l 3
