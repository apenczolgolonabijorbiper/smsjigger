#!/bin/bash

IFS=" " read -r recipient notifynumber <<< $(<$2)
if [[ ! -f ~/sms/cmd/$recipient/generic.sh ]]; then
	echo "recipient @$recipient does not exist"
else
	owner=$(<~/sms/cfg/$recipient/owner.cfg)
	if [[ $1 == $owner ]]; then
		if [[ ! -f ~/sms/cfg/$recipient/notify.cfg ]]; then
			echo "number $notifynumber is not being notified for recipient @$recipient"
		else
			check=$(grep -c $notifynumber ~/sms/cfg/$recipient/notify.cfg)
			if [[ $check -eq 0 ]]; then
				echo "number $notifynumber is not being notified for recipient @$recipient"
			else
				timestamp=`date +%s%N`
				cp ~/sms/cfg/$recipient/notify.cfg ~/sms/cfg/$recipient/notify-old-$timestamp
				cat ~/sms/cfg/$recipient/notify-old-$timestamp | grep -v $notifynumber > ~/sms/cfg/$recipient/notify.cfg
				echo "number $notifynumber removed from being notified for recipient @$recipient"
			fi
		fi
	else
		echo "$1 is not owner of @$recipient, so $notifynumber cannot be set not to be notified"
	fi
fi
