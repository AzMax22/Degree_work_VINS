#!/bin/bash
video=$1

freq_imu=(
    25
    50
    100
)


core_path=/mnt/d/Work/Diplom/model_data_for_VINS/Dataset_EuRoC

mkdir -p $core_path/imu_freq/${video}/results/

evo_ape tum $core_path/gt/${video}.txt  $core_path/original/${video}/VINS.tum --align_origin --save_results $core_path/imu_freq/${video}/results/org.zip

for f in ${freq_imu[@]}
do
    evo_ape tum $core_path/gt/${video}.txt  $core_path/imu_freq/${video}/imu_freq_${f}Hz/imu_freq_${f}Hz.tum --align_origin --save_results $core_path/imu_freq/${video}/results/imu_freq_${f}Hz.zip
done