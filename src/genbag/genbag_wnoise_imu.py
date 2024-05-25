#!/usr/bin/python3
import rosbag
import cv2
from pathlib import Path
import argparse
import numpy as np
import math

GREEN='\033[0;32m'     #  ${GREEN}    # зелёный цвет знаков
NORMAL='\033[0m'      #  ${NORMAL}    # все атрибуты по умолчанию

def add_noise_acc(msg_imu, sigma):
    mean = 0
    gauss = np.random.normal(mean,sigma, size=3)

    msg_imu.linear_acceleration.x += gauss[0]
    msg_imu.linear_acceleration.y += gauss[1]
    msg_imu.linear_acceleration.z += gauss[2]

    return msg_imu

def add_noise_gyr(msg_imu, sigma):
    mean = 0
    gauss = np.random.normal(mean,sigma, size=3)

    msg_imu.angular_velocity.x += gauss[0]
    msg_imu.angular_velocity.y += gauss[1]
    msg_imu.angular_velocity.z += gauss[2]

    return msg_imu

def get_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("sensor", help="Select generate 'gyr' or 'acc' noise", choices=['gyr', 'acc'])
    parser.add_argument("video", help="Which video need shrink", type=str)


    return  parser.parse_args()


def main():
    #получим имя видео из args
    args = get_args()

    tagret_path = f"Dataset_EuRoC/original/{args.video}/{args.video}.bag"

    org_sigma_acc = 0.1
    org_sigma_gyr = 0.01
    org_sigma = 0
    sigma_z = 0 # итоговая сигма, которая получиться после добаления
    core_path_out=""

    if args.sensor == "gyr":
        org_sigma = org_sigma_gyr

    if  args.sensor == "acc":
        org_sigma = org_sigma_acc   

    sigma_z = org_sigma

    for i in range(5):
        sigma_z = 2 * sigma_z

        sigma_x = math.sqrt(sigma_z**2 - org_sigma**2) # сигма, которую нужно добавить чтобы получилась z

        print(f"{GREEN}LOG:{NORMAL}     create {args.sensor}_sigma_{sigma_z}")

        out_path = f"Dataset_EuRoC/wnoise_imu_{args.sensor}/{args.video}/sigma_{sigma_z}/{args.video}.bag"
        
        #create dir
        Path(out_path).parent.mkdir(parents=True, exist_ok=True)
        print(f"{GREEN}LOG:{NORMAL}     Progress:",end="",flush=True)

        with rosbag.Bag(out_path, 'w') as outbag:
            for topic, msg, t in rosbag.Bag(tagret_path).read_messages():

                if topic == "/imu0":
                    print(".",end="", flush=True)  

                    noise_msg = None

                    if args.sensor == "gyr":
                        noise_msg = add_noise_gyr(msg, sigma_x)

                    if  args.sensor == "acc":
                        noise_msg = add_noise_acc(msg, sigma_x)

                    outbag.write(topic, noise_msg, t)
                else:
                    outbag.write(topic, msg, t)

        print("\n")



main()