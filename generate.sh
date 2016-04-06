#!/bin/bash

domains="./domains.txt"

sort -u $domains -o $domains 

if [ -z "$1" ]; then
    ./bricks makpac 'PROXY 127.0.0.1:1080'
else
    ./bricks makpac "$1"
fi

./make-dnsmasq-ipset.sh
