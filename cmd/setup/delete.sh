#!/bin/bash

IFS=" " read -r recipient <<< $(<$2)
if [[ ! -f ~/sms/cmd/$recipient/generic.sh ]]; then
	echo "recipient @$recipient already deleted"
else
	owner=$(<~/sms/cfg/$recipient/owner.cfg)
	if [[ $1 == $owner ]]; then
		timestamp=`date +%s%N`
		mv ~/sms/cmd/$recipient ~/sms/cmd/$recipient-deleted-$timestamp
		mv ~/sms/cfg/$recipient ~/sms/cfg/$recipient-deleted-$timestamp
		mv ~/sms/new/$recipient ~/sms/new/$recipient-deleted-$timestamp
		mv ~/sms/old/$recipient ~/sms/old/$recipient-deleted-$timestamp
		mv ~/sms/log/$recipient ~/sms/log/$recipient-deleted-$timestamp
		mv ~/sms/app/$recipient ~/sms/app/$recipient-deleted-$timestamp
		echo "$1" > ~/sms/cfg/$recipient/owner.cfg
		echo "recipient @$recipient deleted for $1"
	else
		echo "$1 is not owner of @$recipient, so it cannot be deleted"
	fi
fi
