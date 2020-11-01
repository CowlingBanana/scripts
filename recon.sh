#!/bin/bash

echo "running $0 as `whoami` on `date`"

#Global Variables
domain=$1
rootdir=$2
logdir=$rootdir/log
subdir=$rootdir/subdomains
webdir=$rootdir/webservers
detectdir=$rootdir/detections
urldir=$rootdir/urls
portdir=$rootdir/portscan
paramdir=$rootdir/parameters

#blindxss=https://sensei.xss.ht

directory_creation(){
echo directory new style ma
mkdir {$subdir,$logdir,$webdir,$detectdir,$urldir,$portdir,$paramdir}
}
directory_creation

subdomain_enumeration(){

#Subdomain Enumeration Commenced
echo '#Starting recon by enumerating subdomains'
#AMASS
echo 'amass is enumerating subdomains ...........................................'
amass enum -active -d $domain -o $subdir/subdomains_amass_$domain.txt -silent
#SUBFINDER
echo 'subfinder is enumerating subdomains ..........................................'
~/go/bin/subfinder -d $domain -all -cd -o $subdir/subdomains_subfinder_$domain.txt -silent
#CRT.SH
echo 'crt.sh is enumerating subdomains...........................................'
source ~/scripts/crt.sh $domain >> $subdir/subdomains_crt.sh_$domain.txt


#Merge all subdomain files into one
echo 'Merging all collected sub-domains into a single file'
touch $subdir/allsubdomains_$domain.txt
cat $subdir/subdomains_amass_$domain.txt | anew $subdir/allsubdomains_$domain.txt >> $logdir/amass_addedsubs.txt
cat $subdir/subdomains_subfinder_$domain.txt | anew $subdir/allsubdomains_$domain.txt >> $logdir/subfinder_addedsubs.txt
cat $subdir/subdomains_crt.sh_$domain.txt | anew $subdir/allsubdomains_$domain.txt >> $logdir/crt.sh_addedsubs.txt

echo 'Listing the outputs'
echo "A total of (` cat $subdir/allsubdomains_$domain.txt | wc -l `) subdomains were collected and stored in $subdir/allsubdomains_$domain.txt"
}

#Checking Live Webservers
webservers(){
echo Checking live web servers
httpx -l $subdir/allsubdomains_$domain.txt -silent -o $webdir/livewebservers_$domain.txt
}

urls(){
echo Fetching urls using waybackursl
waybackurls $domain >> $urldir/waybackurls_$domain.txt
echo Fetching urls using gau
gau -providers otx commoncrawl $domain >> $urldir/gauurls_$domain.txt
echo Merging both url files into one
touch $urldir/allurls_$domain.txt
cat $urldir/gauurls_$domain.txt | anew $urldir/allurls_$domain.txt >> $logdir/gauurls_$domain.txt
cat $urldir/waybackurls_$domain.txt | anew $urldir/allurls_$domain.txt >> $logdir/waybackurls_$domain.txt
echo Separating Urls by possible Vulnerabilities for XSS SSRF SQLI SSTI
cat $urldir/allurls_$domain.txt | gf ssrf >> $urldir/ssrf_urls_$domain.txt
cat $urldir/allurls_$domain.txt | gf xss >> $urldir/xss_urls_$domain.txt
cat $urldir/allurls_$domain.txt | gf sqli >> $urldir/sqli_urls_$domain.txt
cat $urldir/allurls_$domain.txt | gf ssti >> $urldir/ssti_urls_$domain.txt

}
parameters(){
echo Mining for parameters using paramspider
python3 paramspider.py --domain $domain --exclude woff,css,js,png,svg,php,jpg --output $paramdir/paramspider_$domain.txt --quiet

}
xss(){
cat $urldir/xss_urls_$domain.txt | kxss > $detectdir/kxss_vulnerableurls_$domain.txt 
cat $urldir/xss_urls_$domain.txt | httpx -silent | Gxss -p xss -v -o $detectdir/gxss_vulnerableurls_$domain.txt 
touch $detectdir/all_xss_vulnerableurls_$domain.txt
cat kxss_vulnerableurls_$domain.txt | anew $detectdir/all_xss_vulnerableurls_$domain.txt > $logdir/kxss_vulnerableurls_$domain.txt
cat gxss_vulnerableurls_$domain.txt | anew $detectdir/all_xss_vulnerableurls_$domain.txt > $logdir/gxss_vulnerableurls_$domain.txt
cat $detectdir/all_xss_vulnerableurls_$domain.txt | sort -u | dalfox pipe -b $blindxss
}


#Checking for different vulns using nuclei
vuln_check(){
echo Checking bugs using nuclei
nuclei -t ~/nuclei-templates/cves -l $webdir/livewebservers_$domain.txt -silent -o $detectdir/cvecheck_$domain.txt
}

#PORTSCAN
portscan(){
#masscan and rustscan need to be incorporated
nmap -iL $subdir/allsubdomains_$domain.txt -Pn -sV -vvv -oA $portdir/portscan_results_$domain.txt

}

#FUZZING
fuzzing(){
echo Fuzzing for different things
for line in $(cat $webdir/livewebservers_$domain.txt)
do ffuf -u $line/FUZZ -w ~/wordlists/git_wordlist -ac -mc all
done
}


#subdomain_enumeration
#webservers
#vuln_check
#urls
#xss
#parameters
#sqli
#portscan
#fuzzing
