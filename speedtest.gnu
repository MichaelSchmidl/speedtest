set terminal png

set grid ytics lc rgb "#bbbbbb" lw 1 lt 0
set grid xtics lc rgb "#bbbbbb" lw 1 lt 0

set format y "%3.f MBit"

set xtics ("now" 0, "1d ago" 96, "2d ago" 192, "3d ago" 288, "4d ago" 384, "5d ago" 480, "6d ago" 576, "7d ago" 672, "8d ago" 768)

#set xtics font ", 10"
#set ytics font ", 10"

set datafile separator ","

# find the max value for the DOWNSTREAM - we position the MEAN text above it
set output 'speedtest.png'
plot "< tail -n 700 speedtest.csv | tac" using ($7/1000000)
max_y = GPVAL_DATA_Y_MAX
min_y = GPVAL_DATA_Y_MIN

set output 'speedtest.png'

f(x) = mean_y
fit f(x) "< tail -n 700 speedtest.csv | tac" using ($7/1000000):($7/1000000) via mean_y
stddev_y = sqrt(FIT_WSSR / (FIT_NDF + 1 ))

set label 1 gprintf("%.f MBit mean", mean_y) at 1, mean_y+stddev_y+1
set label 2 gprintf("%.f sigma", stddev_y) at 1, mean_y-stddev_y-2
plot (mean_y+stddev_y) title "" with filledcurves y1=mean_y lt 1 lc rgb "#bbbbdd", \
     (mean_y-stddev_y) title "" with filledcurves y1=mean_y lt 1 lc rgb "#bbbbdd", \
     mean_y title "" with lines, \
     "< tail -n 700 speedtest.csv | tac" using ($7/1000000) title "downstream" with lines, \
     "< tail -n 700 speedtest.csv | tac" using ($8/1000000) title "upstream" with lines


