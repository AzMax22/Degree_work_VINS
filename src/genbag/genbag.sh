#!/bin/bash

GREEN='\033[0;32m'     #  ${GREEN}    # зелёный цвет знаков
NORMAL='\033[0m'      #  ${NORMAL}    # все атрибуты по умолчанию
YELLOW='\033[0;33m' 

bagnames=(
  ##"V1_01_easy"
  #"V1_02_medium"
  #"V1_03_difficult"
  #"V2_01_easy"
  #"V2_02_medium"
  #"V2_03_difficult"
  ##"MH_01_easy"
  ##"MH_02_easy"
  "MH_03_medium"
  ##"MH_04_difficult"
  ##"MH_05_difficult"
)

bag_name="MH_03_medium" 

#for bag_name in ${bagnames[@]}
#do
echo -e "${GREEN}LOG_BASH:${NORMAL} start ${YELLOW}$bag_name ${NORMAL} "
python3 change_resolution.py  $bag_name
#done