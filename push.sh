#!/bin/bash

for filename in $( find ~/sms/out -name "*outinfo*" -type f -not -newermt '-2 seconds' ); do
	dir=${filename%/*}
	folder=${dir##*/}
	cp $filename /var/spool/sms/outgoing 
	mkdir ~/sms/old/$folder 2> /dev/null
	mv $filename ~/sms/old/$folder
done
