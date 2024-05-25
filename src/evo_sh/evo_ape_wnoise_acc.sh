#!/bin/bash
video=V2_01_easy

wnoise_sigma_acc=(
    0.2
    0.4
    0.8
    1.6
    3.2
)


core_path=/mnt/d/Work/Diplom/model_data_for_VINS/Dataset_EuRoC

mkdir -p $core_path/wnoise_imu_acc/${video}/results/

evo_ape tum $core_path/gt/${video}.txt  $core_path/original/${video}/VINS.tum --align_origin --save_results $core_path/wnoise_imu_acc/${video}/results/org.zip

for sigma in ${wnoise_sigma_acc[@]}
do
    evo_ape tum $core_path/gt/${video}.txt  $core_path/wnoise_imu_acc/${video}/sigma_${sigma}/sigma_${sigma}.tum --align_origin --save_results $core_path/wnoise_imu_acc/${video}/results/sigma_${sigma}.zip
done