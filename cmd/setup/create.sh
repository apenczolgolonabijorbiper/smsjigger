#!/bin/bash

IFS=" " read -r recipient <<< $(<$2)
if [[ -f ~/sms/cmd/$recipient/generic.sh ]]; then
	echo "recipient $recipient already exists"
else
	mkdir ~/sms/cmd/$recipient
	cp ~/sms/cmd/setup/generic.sh ~/sms/cmd/$recipient
	mkdir ~/sms/cfg/$recipient
	echo "$1" > ~/sms/cfg/$recipient/owner.cfg
	echo "recipient $recipient created for $1"
fi
