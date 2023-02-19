#!/bin/bash

IFS=" " read -r recipient scriptname <<< $(<$2)
if [[ ! -f ~/sms/cmd/$recipient/generic.sh ]]; then
	echo "recipient $recipient does not exist"
else
	owner=$(<~/sms/cfg/$recipient/owner.cfg)
	if [[ $1 == $owner ]]; then
				if [[ -f ~/sms/cmd/setup/$scriptname.sh  ]]; then
					cp ~/sms/cmd/setup/$scriptname.sh ~/sms/cmd/$recipient
					echo "command #$scriptname installed for recipient @$recipient"
				else
					echo "command #$scriptname cannot be installed for recipient @$recipient"
				fi
	else
		echo "$1 is not owner of recipient @$recipient, so $blocknumber cannot be blacklisted"
	fi
fi
