#!/bin/bash

cd ~/sms

folder=unknown
smsfrom=sender

recipient=$1
shift 1
message="$@"

if [[ 1 -eq 1 ]]; then
	echo sending SMS to $recipient
                mkdir ~/sms/out/$folder 2> /dev/null
                tmpfile=/tmp/$smsfrom.outinfo.`/usr/bin/date +%s%N`
                echo "To: $recipient" > $tmpfile
                echo "" >> $tmpfile
                echo "$message" >> $tmpfile
                mv $tmpfile ~/sms/out/$folder
else
	echo nothing sent
fi
