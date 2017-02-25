#!/bin/bash

echo ""

sensors

echo "---"
echo ""

for temp in $(nvidia-settings -q gpucoretemp | grep Beast: | awk '{print $4}'); do echo "GPU temp: $temp"; done
echo ""
