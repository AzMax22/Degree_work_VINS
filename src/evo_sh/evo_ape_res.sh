#!/bin/bash
video=MH_03_medium

res_str=(
    "432x677"
    "389x609" 
    "350x548" 
    "315x493"
)

core_path=/mnt/d/Work/Diplom/Dataset_EuRoC

for r in ${res_str[@]}
do
    evo_ape tum $core_path/gt/${video}.txt  $core_path/resolution/${video}/res_${r}/${r}.tum --align_origin --save_results $core_path/resolution/${video}/results/${r}.zip
done