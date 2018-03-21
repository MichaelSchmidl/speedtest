#! /bin/bash

echo "`date` `curl -s http://192.168.0.1/xml/CmSystemStatus.xml | grep uptime | tr -d "</cm_system_uptime>PST" | tr "DHM" " " | awk {'print "uptime " $1 " days, " $2 " hours, " $3 " minutes and " $4 " seconds"'}`" >>speedtest_start.log

if [ "$1" == "notify" ]; then
   gnuplot speedtest.gnu
   $HOME/notifymewithpicture.sh "speedtest" "speedtest.png"
else
   ./speedtest-cli --csv >>speedtest.csv || echo ",,,,,,0,0,," >>speedtest.csv
fi

#echo "`date`" >>speedtest_stop.log
