set fit logfile '/dev/null'
set macros
set terminal png size 1024,768
set grid ytics lc rgb "grey" lw 1 lt 0
set grid xtics lc rgb "grey" lw 1 lt 0
set format y "%3.f MBit"
set style fill transparent solid 0.5 noborder

set datafile separator ","
messwerte="< tail -n 700 speedtest.csv | tac"
set xtics ("now" 0*96, "1d ago" 1*96, "2d ago" 2*96, "3d ago" 3*96, "4d ago" 4*96, "5d ago" 5*96, "6d ago" 6*96, "7d ago" 7*96, "8d ago" 8*96, "9" 9*96, "10" 10*96, "11" 11*96, "12" 12*96, "13" 13*96, "14" 14*96)

MB = "1000000"

# find the max and min value for the DOWNSTREAM - we position the MEAN text above it
set output 'speedtest.png'
plot messwerte using ($7/@MB)
max_y = GPVAL_DATA_Y_MAX
min_y = GPVAL_DATA_Y_MIN

# find the mean value of the downstream value
f(x) = mean_y
fit f(x) messwerte using ($7/@MB):($7/@MB) via mean_y
stddev_y = sqrt(FIT_WSSR / (FIT_NDF + 1 ))

# more fancy stuff
samples(x) = $0 > 3 ? 4 : ($0+1)
avg4(x) = (shift4(x), (back1+back2+back3+back4)/samples($0))
shift4(x) = (back4 = back3, back3 = back2, back2 = back1, back1 = x)
init(x) = (back1 = back2 = back3 = back4 = sum = 0)

set output 'speedtest.png'

set label 1 gprintf("%.f MBit mean", mean_y) at 1, max_y+1.5 front
set label 2 gprintf("σ=%.f", stddev_y) at 1, min_y+1.5 front
plot init(0) title "", \
     (mean_y+stddev_y) title "" with filledcurves y1=mean_y lt 1 lc rgb "light-grey", \
     (mean_y-stddev_y) title "" with filledcurves y1=mean_y lt 1 lc rgb "light-grey", \
     mean_y title "" with lines lw 2 lc rgb "dark-red", \
     messwerte using ($7/@MB) title "downstream" with lines lw 1 lc rgb "red", \
     messwerte using ($8/@MB) title "upstream" with lines lc rgb "blue"


