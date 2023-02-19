#!/bin/bash

filename=$2
dir=${filename%/*}
folder=${dir##*/}
file=${filename##*/}
IFS="." read -r smsfrom smsaction smstimestamp <<< $file
recipient=$folder

echo "recipient @$recipient ready to accept #command"
