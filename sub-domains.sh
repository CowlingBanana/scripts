#!/bin/bash
#Script for subdomain enumeration of target domain
intro(){
echo 'Usecase sub-domain.sh -d domain'
echo 'Coded by the legendary leet belikewater the lover of bananas'

}


enumeration(){
#Using Amass Step 1

amass enum --passive -d $1
}


intro
enumeration
