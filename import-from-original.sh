#!/bin/sh

Output="./original.txt"

curl -o $Output https://raw.githubusercontent.com/Leask/BRICKS/master/gfw.bricks
#curl https://raw.githubusercontent.com/wongsyrone/domain-block-list/master/domains.txt >> $Output

cat $Output | xargs ./updater.py -a

rm -rf $Output
