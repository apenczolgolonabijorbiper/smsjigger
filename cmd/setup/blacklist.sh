#!/bin/bash

IFS=" " read -r recipient blocknumber <<< $(<$2)
if [[ ! -f ~/sms/cmd/$recipient/generic.sh ]]; then
	echo "recipient $recipient does not exist"
else
	owner=$(<~/sms/cfg/$recipient/owner.cfg)
	if [[ $1 == $owner ]]; then
		if [[ $owner == $blocknumber ]]; then
			echo "owner cannot be blacklisted for recipient @$recipient"
		else 
			if [[ ! -f ~/sms/cfg/$recipient/blacklist.lst ]]; then
				echo "$blocknumber" >> ~/sms/cfg/$recipient/blacklist.lst
				echo "number $blocknumber blacklisted for recipient @$recipient"
			else
				check=$(grep -c $blocknumber ~/sms/cfg/$recipient/blacklist.lst)
				if [[ $check -eq 0 ]]; then
					timestamp=`date +%s%N`
					cp ~/sms/cfg/$recipient/blacklist.lst ~/sms/cfg/$recipient/blacklist-old-$timestamp
					echo "$blocknumber" >> ~/sms/cfg/$recipient/blacklist.lst
					echo "number $blocknumber blacklisted for recipient @$recipient"
				else
					echo "number $blocknumber is already blacklisted for recipient @$recipient"
				fi
			fi
		fi
	else
		echo "$1 is not owner of recipient @$recipient, so $blocknumber cannot be blacklisted"
	fi
fi
