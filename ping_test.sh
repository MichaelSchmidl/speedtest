CURRENT_LOG=current_ping_problems.log
PERMANENT_LOG=ping_problems.log

if [ "$1" == "check" ]; then
   ping -c 1 google.com
   if [ $? != 0 ]; then
      echo "`date` `curl -s http://192.168.0.1/xml/CmSystemStatus.xml | grep uptime | tr -d "</cm_system_uptime>PST" | tr "DHM" " " | awk {'print "uptime " $1 ":" $2 ":" $3 ":" $4 '}`" >>$CURRENT_LOG
   fi
fi

if [ "$1" == "notify" ]; then
   if [ -f $CURRENT_LOG ]; then
      cat $CURRENT_LOG >>$PERMANENT_LOG
      /home/pi/notifyme.sh "`printf "PING Problems\r"``cat $CURRENT_LOG``printf "\r"`"
      rm $CURRENT_LOG
      ./speedtest.sh notify
   fi
fi

