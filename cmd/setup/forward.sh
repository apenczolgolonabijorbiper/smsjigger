#!/bin/bash

IFS=" " read -r recipient forwardnumber <<< $(<$2)
if [[ ! -f ~/sms/cmd/$recipient/generic.sh ]]; then
	echo "recipient $recipient does not exist"
else
	owner=$(<~/sms/cfg/$recipient/owner.cfg)
	if [[ $1 == $owner ]]; then
		if [[ ! -f ~/sms/cfg/$recipient/forward.cfg ]]; then
			echo "$forwardnumber" >> ~/sms/cfg/$recipient/forward.cfg
			echo "number $forwardnumber added as forward for recipient $recipient"
		else
			check=$(grep -c $forwardnumber ~/sms/cfg/$recipient/forward.cfg)
			if [[ $check -eq 0 ]]; then
				timestamp=`date +%s%N`
				cp ~/sms/cfg/$recipient/forward.cfg ~/sms/cfg/$recipient/forward-old-$timestamp
				echo "$forwardnumber" >> ~/sms/cfg/$recipient/forward.cfg
				echo "number $forwardnumber added as forward for recipient $recipient"
			else
				echo "number $forwardnumber is already forward for recipient $recipient"
			fi
		fi
	else
		echo "$1 is not owner of $recipient, so $forwardnumber cannot be set for forward"
	fi
fi
