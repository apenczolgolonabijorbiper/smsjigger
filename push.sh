#!/bin/bash

#for filename in $( find ~/sms/out -type f -mmin +1 ); do
for filename in $( find ~/sms/out -name "*outinfo*" -type f -not -newermt '-2 seconds' ); do
	#echo file=${filename##*/}
	dir=${filename%/*}
	#echo dir=$dir
	folder=${dir##*/}
	#echo folder=$folder
	cp $filename /var/spool/sms/outgoing 
	mkdir ~/sms/old/$folder 2> /dev/null
	mv $filename ~/sms/old/$folder
done
