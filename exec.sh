#!/bin/bash

cd ~/sms

for filename in $( find ~/sms/new -type f -not -newermt '-2 seconds' -not -name ".gitignore" ); do
	echo reading file $filename
        dir=${filename%/*}
        folder=${dir##*/}
	file=${filename##*/}
	IFS="." read -r smsfrom smsaction smstimestamp <<< $file
	bancheck=0
	if [[ -f ~/sms/cfg/$folder/blacklist.lst ]]; then
		bancheck=$(grep -c $smsfrom ~/sms/cfg/$folder/blacklist.lst)
		echo bancheck1=$bancheck
	fi
	if [[ $bancheck -eq 0 && -f ~/sms/cfg/blacklist.lst ]]; then
		bancheck=$(grep -c $smsfrom ~/sms/cfg/blacklist.lst)
		echo bancheck2=$bancheck
	fi
	if [[ $bancheck -gt 0 ]]; then
		smsinfo="You are not allowed to invoke command #$smsaction for recipient @$folder"
	else	
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
			smsinfo="Recipient or command unknown"
		fi
	fi
	if [[ $smsfrom =~ ^[0-9]+$ ]]; then 
		mkdir ~/sms/out/$folder 2> /dev/null
		tmpfile=/tmp/$smsfrom.outinfo.`/usr/bin/date +%s%N`
		echo "To: $smsfrom" > $tmpfile
		echo "" >> $tmpfile
		echo "$smsinfo" >> $tmpfile
		mv $tmpfile ~/sms/out/$folder
	else
		echo "sender $smsfrom not a mobile number, cannot reply"
	        owner=$(<~/sms/cfg/$folder/owner.cfg)
        	if [[ ! -z $owner ]]; then
			mkdir ~/sms/out/$folder 2> /dev/null
			tmpfile=/tmp/$owner.outinfo.`/usr/bin/date +%s%N`
			echo "To: $owner" > $tmpfile
			echo "" >> $tmpfile
			echo "Received SMS from $smsfrom [$filename]" >> $tmpfile
			mv $tmpfile ~/sms/out/$folder
		fi
	fi
	mkdir ~/sms/old/$folder 2> /dev/null
	mv $filename ~/sms/old/$folder
done
