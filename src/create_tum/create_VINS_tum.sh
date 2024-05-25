#!/bin/bash

GREEN='\033[0;32m'     #  ${GREEN}    # зелёный цвет знаков
NORMAL='\033[0m'      #  ${NORMAL}    # все атрибуты по умолчанию
YELLOW='\033[0;33m' 


arg_flag=$1
# -o = original
# -r = resolution
# -wn_acc = noise withe imu
# -wn_gyr = noise withe imu
# -fi = frequence imu


if [ $# -eq 0 ] # not arg
then
    echo -e "${YELLOW}Please select arg type run:${NORMAL}"
    echo "      -o       original"
    echo "      -r       resolution"
    echo "      -wn_acc  withe noise accelerometer imu"
    echo "      -wn_gyr  withe noise gyroscope imu"
    echo "      -fi      frequence imu"
    exit
fi  

if [ $arg_flag = "-o" ] # original
then
    echo -e "${GREEN}LOG_BASH:${NORMAL} Run type ${YELLOW} original ${NORMAL}"
fi  

if [ $arg_flag = "-r" ] # resolution
then
    echo -e "${GREEN}LOG_BASH:${NORMAL} Run type ${YELLOW} resolution ${NORMAL}"
fi  

if [ $arg_flag = "-wn_acc" ] # noise  accelerometer imu
then
    echo -e "${GREEN}LOG_BASH:${NORMAL} Run type ${YELLOW} wnoise acc imu ${NORMAL}"
fi  

if [ $arg_flag = "-wn_gyr" ] # withe noise gyroscope imu
then
    echo -e "${GREEN}LOG_BASH:${NORMAL} Run type ${YELLOW} wnoise gyr imu ${NORMAL}"
fi 

if [ $arg_flag = "-fi" ] # withe noise gyroscope imu
then
    echo -e "${GREEN}LOG_BASH:${NORMAL} Run type ${YELLOW} freq imu ${NORMAL}"
fi 

res_str=(
    "432x677"
    "389x609" 
    "350x548" 
    "315x493"
)

wnoise_sigma_acc=(
    0.2
    0.4
    0.8
    1.6
    3.2
)

wnoise_sigma_gyr=(
    0.02
    0.04
    0.08
    0.16
    0.32
)

freq_imu=(
    100
    50
    25
)

bagnames=(
  #"V1_01_easy"
  #"V1_02_medium"
  #"V1_03_difficult"
  #"V2_01_easy"
  #"V2_02_medium"
  #"V2_03_difficult"
  "MH_01_easy"
  #"MH_02_easy"
  #"MH_03_medium"
  #"MH_04_difficult"
  #"MH_05_difficult"
)


function kill_all {
    PIDs=$( ps -ef | grep -e ros -e sub.py  | awk '{print $2}')

    for p in ${PIDs[@]}
    do
    kill  $p
    done
}



function run {
    local path_bag=$1 #"/mnt/d/Work/Diplom/Dataset_EuRoC/${type}/${bag_name}/${bag_name}.bag"
    local path_out=$2 #"/mnt/d/Work/Diplom/Dataset_EuRoC/${type}/${bag_name}/VINS.tum"
    local path_config=$3

    #roslaunch vins vins_rviz.launch > /dev/null 2>&1 &   
    roscore > /dev/null 2>&1 &   
    rosrun vins vins_node $path_config  > /dev/null 2>&1 &    
    rosrun loop_fusion loop_fusion_node $path_config > /dev/null 2>&1 &   
    echo -e "${GREEN}LOG_BASH:${NORMAL} run VINS"

    /mnt/d/Work/Diplom/model_data_for_VINS/src/create_tum/sub.py $path_out   &  
    echo -e "${GREEN}LOG_BASH:${NORMAL} run sub.py"

    echo -e "${GREEN}LOG_BASH:${NORMAL} run rosbag"
    rosbag play $path_bag  > /dev/null 2>&1 
    
    kill_all

    pid_sub=$( ps -ef | grep sub.py  | awk '{print $2}')

    #ждем пока не закончиться sub.py 
    while kill -0 $pid_sub 2> /dev/null; do sleep 1; done;

    echo -e "${GREEN}LOG_BASH:${NORMAL} end"
}

bag_name="V1_01_easy" #_short

#for bag_name in ${bagnames[@]}
#do

    if [ $arg_flag = "-o" ] # original
    then
        echo -e "${GREEN}LOG_BASH:${NORMAL} start ${YELLOW} $bag_name ${NORMAL}"
        path_bag="/mnt/d/Work/Diplom/model_data_for_VINS/Dataset_EuRoC/original/${bag_name}/${bag_name}.bag"
        path_out="/mnt/d/Work/Diplom/model_data_for_VINS/Dataset_EuRoC/original/${bag_name}/original.tum"
        path_config=~/catkin_ws/src/VINS-Fusion/config/euroc/euroc_stereo_imu_config.yaml  # БЕЗ КАВЫЧЕК !!!
        run $path_bag $path_out $path_config
    fi  


    if [ $arg_flag = "-r" ] # resolution
    then
        for ((i=0; i < 4; i++)) 
        do 
            echo -e "${GREEN}LOG_BASH:${NORMAL} start ${YELLOW} $bag_name res_${res_str[$i]}${NORMAL}"
            path_bag="/mnt/d/Work/Diplom/model_data_for_VINS/Dataset_EuRoC/resolution/${bag_name}/res_${res_str[$i]}/${bag_name}.bag"
            path_out="/mnt/d/Work/Diplom/model_data_for_VINS/Dataset_EuRoC/resolution/${bag_name}/res_${res_str[$i]}/${res_str[$i]}.tum"
            path_config=~/catkin_ws/src/VINS-Fusion/config/euroc/resolution/res_${res_str[$i]}/euroc_stereo_imu_config.yaml # БЕЗ КАВЫЧЕК !!!
            run $path_bag $path_out $path_config
        done
    fi  

    if [ $arg_flag = "-wn_acc" ] 
    then
        for sigma in ${wnoise_sigma_acc[@]}
        do   
            echo -e "${GREEN}LOG_BASH:${NORMAL} start ${YELLOW} $bag_name sigma_acc_${sigma}"
            path_bag="/mnt/d/Work/Diplom/model_data_for_VINS/Dataset_EuRoC/wnoise_imu_acc/${bag_name}/sigma_${sigma}/${bag_name}.bag"
            path_out="/mnt/d/Work/Diplom/model_data_for_VINS/Dataset_EuRoC/wnoise_imu_acc/${bag_name}/sigma_${sigma}/sigma_${sigma}.tum"
            path_config=~/catkin_ws/src/VINS-Fusion/config/euroc/wnoise_imu_acc/sigma_${sigma}/euroc_stereo_imu_config.yaml  # БЕЗ КАВЫЧЕК !!!
            run $path_bag $path_out $path_config
        done
    fi  

    if [ $arg_flag = "-wn_gyr" ]
    then
        for sigma in ${wnoise_sigma_gyr[@]}
        do  
            echo -e "${GREEN}LOG_BASH:${NORMAL} start ${YELLOW} $bag_name sigma_gyr_${sigma}"
            path_bag="/mnt/d/Work/Diplom/model_data_for_VINS/Dataset_EuRoC/wnoise_imu_gyr/${bag_name}/sigma_${sigma}/${bag_name}.bag"
            path_out="/mnt/d/Work/Diplom/model_data_for_VINS/Dataset_EuRoC/wnoise_imu_gyr/${bag_name}/sigma_${sigma}/sigma_${sigma}.tum"
            path_config=~/catkin_ws/src/VINS-Fusion/config/euroc/wnoise_imu_gyr/sigma_${sigma}/euroc_stereo_imu_config.yaml  # БЕЗ КАВЫЧЕК !!!
            run $path_bag $path_out $path_config
        done
    fi 

    if [ $arg_flag = "-fi" ] # freq imu
    then
        for f in ${freq_imu[@]}
        do 
            echo -e "${GREEN}LOG_BASH:${NORMAL} start ${YELLOW} $bag_name imu_freq_${f}"
            path_bag="/mnt/d/Work/Diplom/model_data_for_VINS/Dataset_EuRoC/imu_freq/${bag_name}/imu_freq_${f}Hz/${bag_name}.bag"
            path_out="/mnt/d/Work/Diplom/model_data_for_VINS/Dataset_EuRoC/imu_freq/${bag_name}/imu_freq_${f}Hz/imu_freq_${f}Hz.tum"
            path_config=~/catkin_ws/src/VINS-Fusion/config/euroc/euroc_stereo_imu_config.yaml  # БЕЗ КАВЫЧЕК !!!
            run $path_bag $path_out $path_config
        done
    fi  
    
#done



