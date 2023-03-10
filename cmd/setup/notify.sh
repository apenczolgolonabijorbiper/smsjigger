#!/bin/bash

IFS=" " read -r recipient notifynumber <<< $(<$2)
if [[ ! -f ~/sms/cmd/$recipient/generic.sh ]]; then
	echo "recipient $recipient does not exist"
else
	owner=$(<~/sms/cfg/$recipient/owner.cfg)
	if [[ $1 == $owner ]]; then
		if [[ ! -f ~/sms/cfg/$recipient/notify.cfg ]]; then
			echo "$notifynumber" >> ~/sms/cfg/$recipient/notify.cfg
			echo "number $notifynumber added as being notified for recipient $recipient"
		else
			check=$(grep -c $notifynumber ~/sms/cfg/$recipient/notify.cfg)
			if [[ $check -eq 0 ]]; then
				timestamp=`date +%s%N`
				cp ~/sms/cfg/$recipient/notify.cfg ~/sms/cfg/$recipient/notify-old-$timestamp
				echo "$notifynumber" >> ~/sms/cfg/$recipient/notify.cfg
				echo "number $notifynumber added as being notified for recipient $recipient"
			else
				echo "number $notifynumber is already notified for recipient $recipient"
			fi
		fi
	else
		echo "$1 is not owner of $recipient, so $notifynumber cannot be set to be notified"
	fi
fi
