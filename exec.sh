#!/bin/bash

cd ~/sms

for filename in $( find ~/sms/new -type f -not -newermt '-2 seconds' -not -name ".gitignore" ); do
	echo reading file $filename
        dir=${filename%/*}
        folder=${dir##*/}
	file=${filename##*/}
	IFS="." read -r smsfrom smsaction smstimestamp <<< $file
	actionscript=$smsaction.sh
	if [[ -f cmd/$folder/$actionscript ]]; then
		cmdresult=$(cmd/$folder/$actionscript $smsfrom $filename)
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
	tmpfile=/tmp/$smsfrom.outinfo.`/usr/bin/date +%s%N`
	echo "To: $smsfrom" > $tmpfile
	echo "" >> $tmpfile
	echo "$smsinfo" >> $tmpfile
	mv $tmpfile ~/sms/out/$folder
	mkdir ~/sms/old/$folder 2> /dev/null
	mv $filename ~/sms/old/$folder
done
