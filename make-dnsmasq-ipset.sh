#!/bin/sh

ConfFile="./dnsmasq-blocklist.conf"
DomainList="./domains.txt"
WhiteList="./white.txt"

sed -i '/^$/d' $DomainList

rm -f $ConfFile 2>&1
cat $DomainList | while read SingleDomain
do
    echo "ipset=/$SingleDomain/gfwlist">>$ConfFile
done

echo "#### Bypass ipset domains">>$ConfFile
cat $WhiteList | while read BypassIpsetDomain
do
    echo "ipset=/$BypassIpsetDomain/#" >>$ConfFile
done

