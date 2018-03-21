#!/bin/bash
#
# notify
curl -s \
  --form-string "token=FILL_IT_IN_HERE" \
  --form-string "user=FILL_IT_IN_HERE" \
  --form-string "message=`hostname`: $1 @ `uptime | cut -d',' -f1`" \
  -F "attachment=@$2" \
  https://api.pushover.net/1/messages.json

