import rosbag
import cv2
from pathlib import Path
import argparse
import numpy as np


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
    parser.add_argument("video", help="Which video need shrink", type=str)
    parser.add_argument("sensor", help="Select generate 'gyr' or 'acc' noise", choices=['gyr', 'acc'])

    return  parser.parse_args()


def main():
    #получим имя видео из args
    args = get_args()

    tagret_path = f"Dataset_EuRoC/original/{args.video}/{args.video}.bag"

    org_sigma_acc = 0.1
    org_sigma_gyr = 0.01
    sigma = 0

    if args.sensor == "gyr":
        sigma = org_sigma_gyr

    if  args.sensor == "acc":
        sigma = org_sigma_acc   

    for i in range(5):
        sigma = 2 * sigma

        print(f"{GREEN}LOG:{NORMAL}     create {args.sensor}_sigma_{sigma}")

        out_path = f"Dataset_EuRoC/wnoise_imu_{args.sensor}/{args.video}/sigma_{sigma}/{args.video}.bag"
        
        #create dir
        Path(out_path).parent.mkdir(parents=True, exist_ok=True)
        print(f"{GREEN}LOG:{NORMAL}     Progress:",end="",flush=True)

        with rosbag.Bag(out_path, 'w') as outbag:
            for topic, msg, t in rosbag.Bag(tagret_path).read_messages():

                if topic == "/imu0":
                    print(".",end="", flush=True)  

                    noise_msg = None

                    if args.sensor == "gyr":
                        noise_msg = add_noise_gyr(msg, sigma)

                    if  args.sensor == "acc":
                        noise_msg = add_noise_acc(msg, sigma)

                    outbag.write(topic, noise_msg, t)
                else:
                    outbag.write(topic, msg, t)

        print("\n")



main()