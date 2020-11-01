#!/bin/bash

domain=$1

#Starting recon by enumerating subdomains
#AMASS
amass enum -active -d $domain -o $domain/subdomains_amass_$domain
#Subfinder
subfinder -d $domain -o $domain/subdomains_subfinder_$domain

#Concatinating Domains into a single file
touch allsubdomains_$domain.txt
cat $domain/subdomains_amass_$domain | anew allsubdomains_$domain.txt >> amass_subs
cat $domain/subdomains_subfinder_$domain | anew allsubdomains_$domain.txt >> subfinder_subs

#Listing the outputs
echo 'Collected' (cat $allsubdomains_$domains.txt wc -l) 'subdomains' 'stored in' allsubdomains_$domain.txt
