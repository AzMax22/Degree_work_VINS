#!/usr/bin/env python3

import rospy
from std_msgs.msg import String
from nav_msgs.msg import Path
import argparse


parser = argparse.ArgumentParser()
parser.add_argument("out_file",help="Where to save the result", type=str)
parser.add_argument('-ul', "--unplug_loop", help="Unplag loop detection when run VINS-FUSION", action='store_true')
args = parser.parse_args()

if args.unplug_loop == True:
    pub_topic = '/vins_estimator/path'
else:
    pub_topic = "/loop_fusion/pose_graph_path"


#create file
my_file = open(f"{args.out_file}", "w+")  
my_file.write("#timestamp x y z q_x q_y q_z q_w\n")

last_msg = None

first_clb_f = False

#Callback function to print the subscribed data on the terminal
def callback(msg):
    global first_clb_f

    if first_clb_f==False:
        print("Listen:",end="", flush=True)
        first_clb_f = True

    print('.', end="", flush=True)

    global last_msg
    last_msg = msg
    

def write_path():
    print('\nWrite:', end="", flush=True)

    global last_msg

    for p in last_msg.poses:
        timestamp = int(str(p.header.stamp.secs) + str(p.header.stamp.nsecs))/ 1e9
        pos = p.pose.position 
        orient = p.pose.orientation

        my_file.write("{} {} {} {} {} {} {} {}\n".format(timestamp, pos.x, pos.y, pos.z ,
                                                          orient.x, orient.y, orient.z, orient.w))

        print('w', end="", flush=True)

    print('\nAll write!')


#Subscriber node function which will subscribe the messages from the Topic
def messageSubscriber():
    #initialize the subscriber node called 'messageSubNode'
    rospy.init_node('SubNode', anonymous=False)
    
    #This is to subscribe to the messages from the topic named 'messageTopic'
    rospy.Subscriber(pub_topic, Path, callback)

    #rospy.spin() stops the node from exitind until the node has been shut down
    rospy.spin()

    write_path()

    my_file.close()


if __name__ == '__main__':
    try: 
        messageSubscriber()
    except rospy.ROSInterruptException:
        pass
        
