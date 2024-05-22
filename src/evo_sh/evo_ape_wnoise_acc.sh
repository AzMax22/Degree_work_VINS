#!/bin/bash
video=V1_01_easy

wnoise_sigma_acc=(
    0.2
    0.4
    0.8
    1.6
    3.2
)


core_path=/mnt/d/Work/Diplom/Dataset_EuRoC

mkdir -p $core_path/wnoise_imu_acc/${video}/results/

for ((i=0; i < 5; i++)) 
do
    sigma=${wnoise_sigma_acc[$i]}
    evo_ape tum $core_path/gt/${video}.txt  $core_path/wnoise_imu_acc/${video}/sigma_${sigma}/sigma_${sigma}.tum --align_origin --save_results $core_path/wnoise_imu_acc/${video}/results/sigma_${sigma}.zip
done