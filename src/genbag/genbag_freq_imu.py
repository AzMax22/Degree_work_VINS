import rosbag
from cv_bridge import CvBridge
import cv2
from pathlib import Path
import argparse


GREEN='\033[0;32m'     #  ${GREEN}    # зелёный цвет знаков
NORMAL='\033[0m'      #  ${NORMAL}    # все атрибуты по умолчанию

ORG_FREQ_IMU = 200


def get_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("video", help="Which video need shrink", type=str)

    return  parser.parse_args()


def main():
    #получим имя видео из args
    args = get_args()
    
    tagret_path = f"Dataset_EuRoC/original/{args.video}/{args.video}.bag"

    curr_freq = ORG_FREQ_IMU

    for i in range(3):

        curr_freq = curr_freq // 2

        print(f"{GREEN}LOG:{NORMAL}     create imu_freq_{curr_freq}Hz")

        out_path = f"Dataset_EuRoC/imu_freq/{args.video}/imu_freq_{curr_freq}Hz/{args.video}.bag"
        
        #create dir
        Path(out_path).parent.mkdir(parents=True, exist_ok=True)
        print(f"{GREEN}LOG:{NORMAL}     Progress:",end="",flush=True)

        with rosbag.Bag(out_path, 'w') as outbag:
            count = 0
            for topic, msg, t in rosbag.Bag(tagret_path).read_messages():
                
                if topic == "/imu0":
                    if count % 2 == 0:
                        print(".",end="", flush=True)
                        outbag.write(topic, msg, t)

                    count+=1
                else:
                    outbag.write(topic, msg, t)

        print("\n")
        tagret_path = out_path            



main()