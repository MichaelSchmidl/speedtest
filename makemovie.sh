MYDIR=tmp

rm -rf $MYDIR
mkdir $MYDIR
cd $MYDIR

CSV_FILE="../speedtest.csv"
MEASUREMENTS_PER_HOUR=4

MEASUREMENTS_PER_DAY=$((MEASUREMENTS_PER_HOUR*24))
MEASUREMENTS_PER_WEEK=$((MEASUREMENTS_PER_DAY*7))

TOTAL_MEASUREMENTS=`awk 'END {print NR}' $CSV_FILE`

FRAME_INCREMENT=$MEASUREMENTS_PER_HOUR
FRAME_START=$MEASUREMENTS_PER_WEEK

rm -rf *.png

printf "            Input file: $CSV_FILE\n"
printf "Number of measurements: $TOTAL_MEASUREMENTS\n"
printf "       Number of hours: $((TOTAL_MEASUREMENTS/$MEASUREMENTS_PER_HOUR))\n"
printf "        Number of days: $((TOTAL_MEASUREMENTS/$MEASUREMENTS_PER_DAY))\n"
printf "       Number of weeks: $((TOTAL_MEASUREMENTS/$MEASUREMENTS_PER_WEEK))\n"
printf "            FrameStart: $FRAME_START\n"
printf "              FrameInc: $FRAME_INCREMENT\n"
printf "       expected frames: $(((TOTAL_MEASUREMENTS-$FRAME_START)/$FRAME_INCREMENT))\n"

FRAME_NR=0
CNT=$FRAME_START
while [ $CNT -le $TOTAL_MEASUREMENTS ]; do
   head -n $CNT $CSV_FILE >speedtest.csv
   gnuplot ../speedtest.gnu
   frame="$(printf "frame%05d.png" $FRAME_NR)"
   printf "       rendering frame: $frame \r"
   cp speedtest.png $frame
   CNT=$((CNT+$FRAME_INCREMENT))
   FRAME_NR=$((FRAME_NR+1))
done

printf "\ngenerating movie now\n"
convert -quality 100 -delay 5 *.png speedtest.mpg

cp speedtest.mpg ..
