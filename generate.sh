#!/bin/bash

./updater.py -s
./bricks makpac 'PROXY 127.0.0.1:1080'
./make-dnsmasq-ipset.sh
