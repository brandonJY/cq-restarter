#!/bin/bash

SERVER_MODE=publish
SERVER_NAME=projectname_${SERVER_MODE}
SERVER_PATH=/apps/aem/${SERVER_NAME}/crx-quickstart/
EMAIL_TEMPLATE=/tmp/email.txt
RECIPIENTS="someone@domain.com"

cd ${SERVER_PATH}
echo "Prcoess ID=$(cat conf/cq.pid)"
echo >logs/stdout.log
bin/stop
bin/start

tail -1f logs/stdout.log | while read line
do
    if echo $line | grep "\[main\] Startup completed"; then
           pkill -P $$ tail
    fi
done

echo startup completed
echo Subject: ${SERVER_NAME} is back online >${EMAIL_TEMPLATE}
echo From: >>${EMAIL_TEMPLATE}
echo To: ${RECIPIENTS} >>${EMAIL_TEMPLATE}
sendmail -t  < ${EMAIL_TEMPLATE}





