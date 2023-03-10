#!/bin/bash

filename=$2
dir=${filename%/*}
folder=${dir##*/}
file=${filename##*/}
IFS="." read -r smsfrom smsaction smstimestamp <<< $file
recipient=$folder

cat $filename
