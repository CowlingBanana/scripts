#!/bin/bash
if [[ $# -eq 0 ]] ;
then
echo "Usage: ./crt.sh domainname"
exit 1
else
curl 'https://crt.sh/?q=%.'$1'&output=json' | jq '.name_value' | sed 's/\"//g' | sed 's/\*\.//g' | sort -u > $1.txt
cat $1.txt
fi
