#!/bin/bash

./import-from-gfwlist.sh
./get-greatfire.sh

read -p "update from original? [Y/N]" yn
if [ "$yn" == "Y" ] || [ "$yn" == "y" ]; then
  echo "updating ..."
  ./import-from-original.sh
fi
