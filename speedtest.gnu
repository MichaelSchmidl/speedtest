set terminal png

set grid ytics lc rgb "#bbbbbb" lw 1 lt 0
set grid xtics lc rgb "#bbbbbb" lw 1 lt 0

#set arrow from graph 0,first 100.0 to graph 1,first 100.0 nohead lc rgb "#FF00FF" front
#set arrow from graph 0,first 12.0 to graph 1,first 12.0 nohead lc rgb "#FF0000" front

set format y "%3.f MBit"

#set format x "%3.fh"
#set xtics 96
set xtics ("now" 0, "1d ago" 96, "2d ago" 192, "3d ago" 288, "4d ago" 384, "5d ago" 480, "6d ago" 576, "7d ago" 672, "8d ago" 768)

#set xtics font ", 10"
#set ytics font ", 10"

n = 700

set datafile separator ","

# find the max value for the UPSTREAM - we position the MEAN text above it
set output 'speedtest.png'
plot "< tail -n 700 speedtest.csv | tac" using ($7/1000000)
max_y = GPVAL_DATA_Y_MAX
min_y = GPVAL_DATA_Y_MIN

set output 'speedtest.png'

f(x) = mean_y
fit f(x) "< tail -n 700 speedtest.csv | tac" using 7:7 via mean_y
set label 1 gprintf("%.f MBit mean", mean_y/1000000) at 1, max_y + 1

plot mean_y/1000000 title "" with lines, \
     "< tail -n 700 speedtest.csv | tac" using ($7/1000000) title "downstream" with lines, \
     "< tail -n 700 speedtest.csv | tac" using ($8/1000000) title "upstream" with lines

