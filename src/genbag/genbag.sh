#!/bin/bash

GREEN='\033[0;32m'     #  ${GREEN}    # зелёный цвет знаков
NORMAL='\033[0m'      #  ${NORMAL}    # все атрибуты по умолчанию
YELLOW='\033[0;33m' 

GENBAG_DIR="/mnt/d/Work/Diplom/model_data_for_VINS/src/genbag"

arg_flag=$1
# -o = original
# -r = resolution
# -wn_acc = noise withe imu
# -wn_gyr = noise withe imu
# -fi = frequence imu


if [ $# -eq 0 ] # not arg
then
    echo -e "${YELLOW}Please select arg type run:${NORMAL}"
    echo "      -r       resolution"
    echo "      -wn_acc  withe noise accelerometer imu"
    echo "      -wn_gyr  withe noise gyroscope imu"
    echo "      -fi      frequence imu"
    exit
fi  


if [ $arg_flag = "-r" ] # resolution
then
    echo -e "${GREEN}LOG_BASH:${NORMAL} Run type ${YELLOW} resolution ${NORMAL}"
    COMMAND="${GENBAG_DIR}/genbag_resolution.py"
fi  

if [ $arg_flag = "-wn_acc" ] # noise  accelerometer imu
then
    echo -e "${GREEN}LOG_BASH:${NORMAL} Run type ${YELLOW} wnoise acc imu ${NORMAL}"
    COMMAND="${GENBAG_DIR}/genbag_wnoise_imu.py acc"
fi  

if [ $arg_flag = "-wn_gyr" ] # withe noise gyroscope imu
then
    echo -e "${GREEN}LOG_BASH:${NORMAL} Run type ${YELLOW} wnoise gyr imu ${NORMAL}"
     COMMAND="${GENBAG_DIR}/genbag_wnoise_imu.py gyr"
fi 

if [ $arg_flag = "-fi" ] # withe noise gyroscope imu
then
    echo -e "${GREEN}LOG_BASH:${NORMAL} Run type ${YELLOW} freq imu ${NORMAL}"
    COMMAND="${GENBAG_DIR}/genbag_freq_imu.py"
fi 


bagnames=(
  ##"V1_01_easy"
  #"V1_02_medium"
  #"V1_03_difficult"
  "V2_01_easy"
  "V2_02_medium"
  "V2_03_difficult"
  ##"MH_01_easy"
  ##"MH_02_easy"
  #"MH_03_medium"
  #"MH_04_difficult"
  ##"MH_05_difficult"
)

#bag_name="MH_03_medium" 

for bag_name in ${bagnames[@]}
do
  echo -e "${GREEN}LOG_BASH:${NORMAL} start ${YELLOW}$bag_name ${NORMAL} "
  python3 ${COMMAND}  $bag_name
done