#!/bin/sh

/usr/bin/screen -dm -S raspi -h 5000 ./run

# start the IOC in a screen session
#  type:
#   screen -r   to start interacting with the IOC command line
#   ^a-d        to stop interacting with the IOC command line
#   ^c          to stop the IOC
