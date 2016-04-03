#!/bin/sh
# dir=${PWD##*/}

wget https://raw.githubusercontent.com/gfwlist/gfwlist/master/gfwlist.txt -O ./gfwlist.txt --no-check-certificate

cat ./gfwlist.txt | ./import-from-gfwlist.js

rm -rf ./gfwlist.txt
