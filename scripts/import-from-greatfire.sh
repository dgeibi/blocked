#!/bin/sh

set -x
tmp="$(mktemp)"
Threshold=60
for i in $( seq 0 10 )
do
    curl -s --insecure "https://zh.greatfire.org/search/alexa-top-1000-domains?page=$i"|  \
        grep 'class="first"' | grep 'class="blocked"' | grep -vE "google"|\
        sed -e "s#^[^\/]*\/\([^\"]*\)[^\%]*\%...\([^\%]*\)\%.*#\1 \2#g"|\
        awk '$2>='"$Threshold"' {print ""$1"" }'\
        >>$tmp
    curl -s --insecure "https://zh.greatfire.org/search/domains?page=$i"|  \
        grep 'class="first"' | grep 'class="blocked"' | grep -vE "google"|\
        grep -vE "facebook"| grep -vE "twitter"|\
        sed -e "s#^[^\/]*\/\([^\"]*\)[^\%]*\%...\([^\%]*\)\%.*#\1 \2#g"|\
        sed -e "s#^https/##g" |\
        awk '$2>='"$Threshold"' {print ""$1"" }'\
        >>$tmp
done
sed -i '/^url\b/'d $tmp
./bricks adds $tmp
rm -rf $tmp
