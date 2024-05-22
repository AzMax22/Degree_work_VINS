#!/bin/bash

PIDs=$( ps -ef | grep -e sub.py -e ros | awk '{print $2}')

for p in ${PIDs[@]}
do
echo $p
kill -9 $p
done