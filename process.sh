#!/bin/bash

cd ~/sms

for filename in $( find ~/sms/got -name "GSM*" -o -name "USB*" -type f -not -newermt '-2 seconds' ); do
	echo reading file $filename
	i=1
	istext=""
	smstext=""
	while IFS= read line || [ -n "$line" ]; do
		[ -z "$line" ] && continue
		if [[ -z $istext ]]; then
			IFS=":" read -r linekey linevalue <<< $line
			if [[ $linekey == "From" ]]; then
				IFS=": " read -r linekey linevalue <<< $line
				smsfrom=$linevalue
				smsfrom=${smsfrom/ /}
			fi
			if [[ $linekey == "Sent" ]]; then
				IFS=": " read -r linekey linevalue <<< $line
				smsdate=$linevalue
			fi
			if [[ $linekey == "Length" ]]; then
				istext=yes
			fi
		else
			smstext=$smstext$line
		fi
		i=$((i+1))
	done < $filename
	IFS=" " read -r smsrecipient smscommand smstext2 <<< $smstext
	if [[ $smsrecipient == "@"* ]]; then
		smsto=${smsrecipient/@/}
		if [[ $smscommand == "#"* ]]; then
			smsaction=${smscommand/\#/}
		else
			smsaction=generic
			IFS=" " read -r smsrecipient smstext2 <<< $smstext
		fi

	else
		smsto=unknown
		smsaction=received
		smstext2=$smstext
	fi
	if [[ -s ~/sms/cfg/$smsto/notify.cfg ]]; then
		notify=$(<~/sms/cfg/$smsto/notify.cfg)
		timestamp=$(/usr/bin/date +%s%N)
		echo "notifying $notify about this SMS from $smsfrom for @$smsto"
		echo "received SMS from $smsfrom for @$smsto with content [$smstext2]" > new/$smsto/$notify.info.$timestamp
	fi
	timestamp=$(/usr/bin/date +%s%N)
	echo from=$smsfrom, to=$smsto, date=$smsdate, text=$smstext2
	echo timestamp=$timestamp
	mv $filename old/gsm
	mkdir new/$smsto 2> /dev/null
	echo $smstext2 > new/$smsto/$smsfrom.$smsaction.$timestamp
done
