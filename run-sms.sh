#!/bin/bash

cd ~/sms

now=`date +%Y%m%d_%H%M%S`
day=`date +%Y%m%d`

script=$(basename -- "$0")
scriptname=`basename $0`
check=$(ps x | grep "$script" | grep -v grep | grep -v $$ | wc -l)

logfile=log/${scriptname}-${day}.log

echo timestamp $now


if [[ ${check} -gt 2 ]]; then
        ps x | grep "$script" | grep -v grep | grep -v $$
        echo script ${script} already running, exiting
        echo `date +%Y%m%d_%H%M%S` script ${script} already running, exiting  >> ${logfile}
        exit
fi


exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>>${logfile} 2>&1

echo starting `date +%Y%m%d_%H%M%S`


while true
do
	echo running..
	~/sms/fetch.sh && ~/sms/process.sh  && ~/sms/exec.sh && ~/sms/push.sh 2>&1 >> ~/sms/log/fetch-process-exec-push.log
	sleep 3
done
