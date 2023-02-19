#!/bin/bash

filename=$2
dir=${filename%/*}
folder=${dir##*/}
file=${filename##*/}
IFS="." read -r smsfrom smsaction smstimestamp <<< $file
recipient=$folder

cmdresult=$(ls ~/sms/cmd/$recipient/*.sh | xargs -n1 basename)
cmdresult=${cmdresult//.sh/}
cmdresult=${cmdresult//generic/}

echo "recipient @$recipient accepts following commands: $cmdresult"
