#!/bin/bash

#for i in $( find /var/spool/sms/incoming -type f -mmin +1 ); do
for i in $( find /var/spool/sms/incoming -type f -not -newermt '-2 seconds' ); do
	mv $i ~/sms/got
done
