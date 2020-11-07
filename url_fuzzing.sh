#!/bin/bash

echo "Usecase is $0 url_file wordlist_file"

for line in $(cat $1)
    do ffuf -u $line/FUZZ -w $2 -mc 200 -t 200 -replay-proxy http://127.0.0.1:8080
done

