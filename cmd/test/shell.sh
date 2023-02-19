#!/bin/bash

smsfrom=$1
smstext=$2
if [[ -f $smstext ]]; then
	cmd=$(<$smstext)
	cmdresult=$($cmd)
	echo $cmdresult
else
	echo "shell command not found"
fi
