#!/bin/bash

BLOCKED="./blocked.txt"

./scripts/import-from-github.sh
./scripts/import-from-greatfire.sh

sort -u $BLOCKED -o $BLOCKED

if [ -z "$1" ]; then
    ./bricks makpac 'PROXY 127.0.0.1:1080'
else
    ./bricks makpac "$1"
fi

./scripts/make-dnsmasq-ipset.sh
