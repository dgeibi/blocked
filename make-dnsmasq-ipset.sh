#!/bin/sh

ConfFile="./dnsmasq-blocklist.conf"
DomainList="./domains.txt"
sed -i '/^$/d' $DomainList

rm -f $ConfFile 2>&1
cat $DomainList | while read SingleDomain
do
    echo "ipset=/$SingleDomain/gfwlist">>$ConfFile
done

echo "#### Bypass ipset domains">>$ConfFile
cat <<'EOF' | while read BypassIpsetDomain
redirector.gvt1.com
cn.bing.com
EOF
do
    echo "ipset=/$BypassIpsetDomain/#" >>$ConfFile
done

