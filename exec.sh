#!/bin/bash

cd ~/sms

#for filename in $( find ~/sms/new -type f -mmin +1 ); do
for filename in $( find ~/sms/new -type f -not -newermt '-2 seconds' -not -name ".gitignore" ); do
	echo reading file $filename
        dir=${filename%/*}
        #echo dir=$dir
        folder=${dir##*/}
	#echo folder=$folder
	file=${filename##*/}
	#echo file=$file
	IFS="." read -r smsfrom smsaction smstimestamp <<< $file
	#echo smsfrom=$smsfrom
	#echo smsaction=$smsaction
	#echo smstimestamp=$smstimestamp
	actionscript=$smsaction.sh
	if [[ -f cmd/$folder/$actionscript ]]; then
		#echo action script exists
		#smstext=$(<filename)
		cmdresult=$(cmd/$folder/$actionscript $smsfrom $filename)
		#echo cmdresult=$cmdresult
		mkdir log/$folder/ 2> /dev/null
		echo "=======`date +%Y%m%d_%H%M%S` === from: $smsfrom, smstext: $file" >> log/$folder/$actionscript.log
		echo $cmdresult >> log/$folder/$actionscript.log
		echo "=======" >> log/$folder/$actionscript.log
		smsinfo="$cmdresult"

	else
		echo action script does not exists
		smsinfo="Komenda nieznana"
	fi
	mkdir ~/sms/out/$folder 2> /dev/null
	#printf "To: $smsfrom\n\n$smsinfo" > ~/sms/out/$folder/$smsfrom.outinfo.`/usr/bin/date +%s%N`
	tmpfile=/tmp/$smsfrom.outinfo.`/usr/bin/date +%s%N`
	echo "To: $smsfrom" > $tmpfile
	echo "" >> $tmpfile
	echo "$smsinfo" >> $tmpfile
	mv $tmpfile ~/sms/out/$folder
	mkdir ~/sms/old/$folder 2> /dev/null
	mv $filename ~/sms/old/$folder
done
