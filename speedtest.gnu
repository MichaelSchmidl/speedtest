set fit quiet
set fit logfile '/dev/null'
set macros
set terminal png size 1024,768
set grid ytics lc rgb "grey" lw 1 lt 0
set grid xtics lc rgb "grey" lw 1 lt 0
set format y "%3.f MBit"
set style fill transparent solid 0.5 noborder
set datafile separator ","

set xtics ( "now" 0*96, "1d ago" 1*96, "2d ago" 2*96, "3d ago" 3*96, "4d ago" 4*96, "5d ago" 5*96, "6d ago" 6*96, "7d ago" 7*96, "8d ago" 8*96, "9" 9*96, "10" 10*96, "11" 11*96, "12" 12*96, "13" 13*96, "14" 14*96)

MB = "1000000"
N_MESSWERTE = "700"

messwerte = "< tail -n 700 speedtest.csv | tac | awk '{print $4\",\"$7\",\"$8}' FS=,"
now = system("tail -n 1 speedtest.csv | awk '{print $4}' FS=, | awk '{ gsub(/\\.[0-9]+/, \"\"); print}' | sed s/T/\" \"/g  | sed s/Z//g")

# set MAX, MIN, MEAN and STDDEV for the two data columns
stats messwerte using  ($2/@MB) name  "downstream" nooutput
stats messwerte using  ($3/@MB) name  "upstream" nooutput

set output 'speedtest.png'
set label 1 sprintf("%.f MBit, σ=%.f, %s UTC", downstream_mean, downstream_stddev, now) at 1, downstream_max+0.5 front
set label 2 sprintf("%.f MBit, σ=%.f", upstream_mean, upstream_stddev) at 1, upstream_max+0.5 front
plot (downstream_mean+downstream_stddev) title "" with filledcurves y1=downstream_mean lt 1 lc rgb "light-grey", \
     (downstream_mean-downstream_stddev) title "" with filledcurves y1=downstream_mean lt 1 lc rgb "light-grey", \
     downstream_mean title "" with lines lw 2 lc rgb "dark-red", \
     (upstream_mean+upstream_stddev) title "" with filledcurves y1=upstream_mean lt 1 lc rgb "light-grey", \
     (upstream_mean-upstream_stddev) title "" with filledcurves y1=upstream_mean lt 1 lc rgb "light-grey", \
     upstream_mean title "" with lines lw 2 lc rgb "dark-red", \
     messwerte using ($2/@MB) title "downstream" with lines lw 1 lc rgb "red", \
     messwerte using ($3/@MB) title "upstream" with lines lc rgb "blue"


