#!/bin/sh

ConfFile="./dnsmasq-blocklist.conf"
GFWList="./blocked.txt"
WhiteList="./white.txt"
SetName="gfwlist"
if [[ -n "$1" ]]; then
    SetName="$1"
fi

sed -i '/^$/d' $GFWList

rm -f $ConfFile 2>&1
cat $GFWList | while read SingleDomain
do
    echo "ipset=/$SingleDomain/$SetName">>$ConfFile
done

echo "#### Bypass ipset domains">>$ConfFile
cat $WhiteList | while read BypassIpsetDomain
do
    echo "ipset=/$BypassIpsetDomain/#" >>$ConfFile
done
