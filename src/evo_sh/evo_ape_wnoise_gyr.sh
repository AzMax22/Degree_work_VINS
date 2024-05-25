#!/bin/bash
video=V1_01_easy

wnoise_sigma_gyr=(
    0.02
    0.04
    0.08
    0.16
    0.32
)


core_path=/mnt/d/Work/Diplom/model_data_for_VINS/Dataset_EuRoC

mkdir -p $core_path/wnoise_imu_gyr/${video}/results/

evo_ape tum $core_path/gt/${video}.txt  $core_path/original/${video}/VINS.tum --align_origin --save_results $core_path/wnoise_imu_gyr/${video}/results/org.zip

for sigma in ${wnoise_sigma_gyr[@]}
do
    evo_ape tum $core_path/gt/${video}.txt  $core_path/wnoise_imu_gyr/${video}/sigma_${sigma}/sigma_${sigma}.tum --align_origin --save_results $core_path/wnoise_imu_gyr/${video}/results/sigma_${sigma}.zip
done