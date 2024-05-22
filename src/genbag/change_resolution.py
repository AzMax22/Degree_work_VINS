import rosbag
from cv_bridge import CvBridge
import cv2
from pathlib import Path
import argparse


GREEN='\033[0;32m'     #  ${GREEN}    # зелёный цвет знаков
NORMAL='\033[0m'      #  ${NORMAL}    # все атрибуты по умолчанию

SCALE_DOWN = 0.9

ORG_HEIGHT = 480
ORG_WIDTH =752

def shrink_image(msg_img):
    # создадим cv_bridge для конвертации cv и msgs_image(ROS)
    bridge = CvBridge()

    cv_image = bridge.imgmsg_to_cv2(msg_img, desired_encoding='passthrough')
    

    resized = cv2.resize(cv_image, None, fx= SCALE_DOWN, fy= SCALE_DOWN, interpolation=cv2.INTER_AREA)

    new_msg_img =  bridge.cv2_to_imgmsg(resized, encoding="passthrough")

    new_msg_img.header = msg_img.header

    return new_msg_img


def get_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("video", help="Which video need shrink", type=str)

    return  parser.parse_args()


def main():
    #получим имя видео из args
    args = get_args()
    
    tagret_path = f"Dataset_EuRoC/original/{args.video}/{args.video}.bag"

    curr_height = ORG_HEIGHT
    curr_width =ORG_WIDTH

    for i in range(1,5):
        curr_height = round(curr_height * SCALE_DOWN)
        curr_width = round(curr_width * SCALE_DOWN)

        print(f"{GREEN}LOG:{NORMAL}     create res_{curr_height}x{curr_width}")

        out_path = f"Dataset_EuRoC/resolution/{args.video}/res_{curr_height}x{curr_width}/{args.video}.bag"
        
        #create dir
        Path(out_path).parent.mkdir(parents=True, exist_ok=True)
        print(f"{GREEN}LOG:{NORMAL}     Progress:",end="",flush=True)

        with rosbag.Bag(out_path, 'w') as outbag:
            for topic, msg, t in rosbag.Bag(tagret_path).read_messages():

                if topic == "/cam1/image_raw" or topic == "/cam0/image_raw":
                    print(".",end="", flush=True)      
                    
                    shr_msg = shrink_image(msg)

                    outbag.write(topic, shr_msg, t)
                else:
                    outbag.write(topic, msg, t)

        print("\n")
        tagret_path = out_path            



main()