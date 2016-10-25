#!/bin/sh

tmp="$(mktemp)"

curl -o $tmp https://raw.githubusercontent.com/Leask/BRICKS/master/gfw.bricks
curl https://raw.githubusercontent.com/wongsyrone/domain-block-list/master/domains.txt >> $tmp
sed -i "/v2ex/d" $tmp

./bricks adds $tmp
rm -rf $tmp
