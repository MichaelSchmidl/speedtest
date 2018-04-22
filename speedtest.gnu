set fit quiet
set fit logfile '/dev/null'
set macros
set terminal png size 1024,768
set grid ytics lc rgb "grey" lw 1 lt 0
set grid xtics lc rgb "grey" lw 1 lt 0
set format y "%3.f MBit"
set style fill transparent solid 0.5 noborder
set xtics ("now" 0*96, "1d ago" 1*96, "2d ago" 2*96, "3d ago" 3*96, "4d ago" 4*96, "5d ago" 5*96, "6d ago" 6*96, "7d ago" 7*96, "8d ago" 8*96, "9" 9*96, "10" 10*96, "11" 11*96, "12" 12*96, "13" 13*96, "14" 14*96)
set datafile separator ","

MB = "1000000"
N_MESSWERTE = "700"

messwerte = "< tail -n 700 speedtest.csv | tac"

# find the max and min value for the DOWNSTREAM - we position the MEAN text above it
set output 'speedtest.png'
plot messwerte using ($7/@MB)
maxdown_y = GPVAL_DATA_Y_MAX
mindown_y = GPVAL_DATA_Y_MIN

# find the max and min value for the UPSTREAM - we position the MEAN text above it
plot messwerte using ($8/@MB)
maxup_y = GPVAL_DATA_Y_MAX
minup_y = GPVAL_DATA_Y_MIN

# find the mean value of the downstream values
f(x) = meandown_y
fit f(x) messwerte using ($7/@MB):($7/@MB) via meandown_y
stddevdown_y = sqrt(FIT_WSSR / (FIT_NDF + 1 ))

# find the mean value of the upstream values
f(x) = meanup_y
fit f(x) messwerte using ($8/@MB):($8/@MB) via meanup_y
stddevup_y = sqrt(FIT_WSSR / (FIT_NDF + 1 ))

set output 'speedtest.png'

set label 1 sprintf("%.f MBit down with σ=%.f", meandown_y, stddevdown_y) at 1, maxdown_y+0.5 front
set label 2 sprintf("%.f MBit up with σ=%.f", meanup_y, stddevup_y) at 1, maxup_y+0.5 front
plot (meandown_y+stddevdown_y) title "" with filledcurves y1=meandown_y lt 1 lc rgb "light-grey", \
     (meandown_y-stddevdown_y) title "" with filledcurves y1=meandown_y lt 1 lc rgb "light-grey", \
     meandown_y title "" with lines lw 2 lc rgb "dark-red", \
     (meanup_y+stddevup_y) title "" with filledcurves y1=meanup_y lt 1 lc rgb "light-grey", \
     (meanup_y-stddevup_y) title "" with filledcurves y1=meanup_y lt 1 lc rgb "light-grey", \
     meanup_y title "" with lines lw 2 lc rgb "dark-red", \
     messwerte using ($7/@MB) title "downstream" with lines lw 1 lc rgb "red", \
     messwerte using ($8/@MB) title "upstream" with lines lc rgb "blue"


