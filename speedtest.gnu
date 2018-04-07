set fit logfile '/dev/null'
set macros
set terminal png
set grid ytics lc rgb "grey" lw 1 lt 0
set grid xtics lc rgb "grey" lw 1 lt 0
set format y "%3.f MBit"

set datafile separator ","
messwerte="< tail -n 700 speedtest.csv | tac"
set xtics ("now" 0*96, "1" 1*96, "2" 2*96, "3" 3*96, "4" 4*96, "5" 5*96, "6" 6*96, "7" 7*96, "8" 8*96, "9" 9*96, "10" 10*96, "11" 11*96, "12" 12*96, "13" 13*96, "14" 14*96)

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

set label 1 gprintf("%.f MBit mean", mean_y) at 1, mean_y+stddev_y+1.5
set label 2 gprintf("σ=%.f", stddev_y) at 1, min_y+1.5
plot init(0) title "", \
     (mean_y+stddev_y) title "" with filledcurves y1=mean_y lt 1 lc rgb "light-grey", \
     (mean_y-stddev_y) title "" with filledcurves y1=mean_y lt 1 lc rgb "light-grey", \
     mean_y title "" with lines lw 3 lc rgb "dark-red", \
     messwerte using ($7/@MB) title "" pt 1 ps 0.5 lw 1 lc rgb "light-red", \
     messwerte using ($7/@MB) title "" with lines lw 0.2 lc rgb "light-red", \
     messwerte using ($8/@MB) title "" with lines lc rgb "blue", \
     messwerte using (avg4($7/@MB)) title "" with lines lw 2 lc rgb "dark-red", \
     messwerte using (sum = sum + ($7/@MB), sum/($0+1)) title "" with lines lw 2 lc rgb "dark-green"


