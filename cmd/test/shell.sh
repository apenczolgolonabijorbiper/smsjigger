#!/bin/bash

smsfrom=$1
smstext=$2
if [[ -f $smstext ]]; then
	cmd=$(<$smstext)
	cmdresult=$($cmd)
	echo $cmdresult
else
	echo "komenda shell nie znaleziona"
fi
