#!/bin/bash

filename=$2
        #echo reading file $filename
        dir=${filename%/*}
        folder=${dir##*/}
        file=${filename##*/}
        IFS="." read -r smsfrom smsaction smstimestamp <<< $file

IFS=" " read -r listname <<< $(<$filename)
mkdir ~/sms/app/$folder 2> /dev/null

			if [[ ! -f ~/sms/app/$folder/$listname.lst ]]; then
				echo "$1" >> ~/sms/app/$folder/$listname.lst
				echo "number $1 added to list $listname"
			else
				check=$(grep -c $1 ~/sms/app/$folder/$listname.lst)
				if [[ $check -eq 0 ]]; then
					timestamp=`date +%s%N`
					cp ~/sms/app/$folder/$listname.lst ~/sms/app/$folder/$listname-old-$timestamp
					echo "$1" >> ~/sms/app/$folder/$listname.lst
					echo "number $1 added to list $listname"
				else
					echo "number $1 is already on list $listname"
				fi
			fi
