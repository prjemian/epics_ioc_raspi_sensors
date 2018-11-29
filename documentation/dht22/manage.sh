#!/bin/bash
# init file for logging DHT22 sensor data
#
# description: logging DHT22 sensor data
#
# processname: dht22_logging

PROCESS_NAME=dht22_logging
PROCESS_DIR=/home/pi/Documents/Adafruit_Python_DHT/examples

EXECUTABLE_COMMAND=/usr/bin/python
COMMAND_OPTIONS=" ${PROCESS_DIR}/continuous.py ${PROCESS_DIR}/log.txt"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

SNAME=$0
SELECTION=$1

PROJECT_DIR=`dirname ${SNAME}`
LOGFILE=${PROJECT_DIR}/log-${PROCESS_NAME}.txt
SCREEN_COMMAND="screen -d -m -mS ${PROCESS_NAME} -h 5000 ${EXECUTABLE_COMMAND} ${COMMAND_OPTIONS}"
REPORT_TEXT="${PROCESS_NAME}"
RETVAL=0
HOST=`/bin/hostname`


get_sockname(){
    # SOCKNAME=${PID}.${PROCESS_NAME}
    SOCKNAME=`screen -ls | grep ${PROCESS_NAME} | awk '{print $1;}'`
}


get_pid(){
    get_sockname
    if [ "${SOCKNAME}" == "" ]; then
        PID=""
    else
        PID=`echo ${SOCKNAME} | cut -d "." -f1`
    fi
}


caget_test(){
    # TODO: verify responsiveness by testing with caget
    return 0
}


check_pid_running(){
    get_pid
    if [ "${PID}" == "" ]; then
        # no PID found
        RETVAL=1
    else
        # found a PID with our process name attached
        caget_test
        RETVAL=0
    fi
    return ${RETVAL}
}


start(){
    if check_pid_running; then
        msg="# [$0 `/bin/date`] running ${PROCESS_NAME} with PID=${PID}: ${REPORT_TEXT}"
        /bin/echo ${msg} 2>&1 >> ${LOGFILE} &
        /bin/echo ${msg}
    else
        cd ${PROJECT_DIR}
        ${SCREEN_COMMAND} 2>&1 >> ${LOGFILE} &
        sleep 1
        get_pid
        msg="# [$0 `/bin/date`] started ${REPORT_TEXT}"
        msg+=" PID=${PID}"
        msg+=" USER=${USER}"
        msg+=" HOST=${HOST}"
        /bin/echo ${msg} 2>&1 >> ${LOGFILE} &
        /bin/echo ${msg}
    fi
}


stop(){
    if check_pid_running; then
        kill ${PID}
        msg="# [$0 `/bin/date`] stopped ${PID}: ${REPORT_TEXT}"
        /bin/echo ${msg} 2>&1 >> ${LOGFILE} &
        /bin/echo ${msg}
    else
        msg="# [$0 `/bin/date`] not running ${PID}: ${REPORT_TEXT}"
        echo ${msg} 2>&1 >> ${LOGFILE} &
    fi
}


restart(){
    stop
    start
}


status() {
    if check_pid_running; then
        echo "${PROCESS_NAME} is running PID=${PID} SOCKNAME=${SOCKNAME}"
    else
        echo "${PROCESS_NAME} is not running"
    fi
}


console(){
    if check_pid_running; then
        cd ${PROJECT_DIR}
        screen -r ${SOCKNAME}
    else
        msg="# [$0 `/bin/date`] no such screen process found"
        msg+=": ${PROCESS_NAME}"
        echo ${msg}
        echo ${msg} 2>&1 >> ${LOGFILE} &
    fi
}


checkup(){
    #=====================
    # call periodically (every 5 minutes) to see if process is running
    #=====================
    #	     field	    allowed values
    #	   -----	  --------------
    #	   minute	  0-59
    #	   hour 	  0-23
    #	   day of month   1-31
    #	   month	  1-12 (or names, see below)
    #	   day of week    0-7 (0 or 7 is Sun, or use names)
    #
    # */5 * * * * /full/path/to/this/script.sh checkup 2>&1 > /dev/null

    check_pid_running
    RV=${RETVAL}
    # echo "RETVAL=${RV}"
    
    msg="# [$0 `/bin/date`] "
    if [ $RV == 0 ]; then
        msg+="running fine, so it seems"
        echo ${msg} 2>&1 > /dev/null
    else
        msg+="could not identify running process ${PID}"
        msg+=", starting new process"
        echo ${msg} 2>&1 > /dev/null
        start
    fi
}


case "$1" in
  start)
    start
    ;;
  stop)
    stop
    ;;
  restart)
    restart
    ;;
  status)
    status
    ;;
  checkup)
    checkup
    ;;
  console)
    console
    ;;
  *)
    echo $"Usage: $0 {start|stop|restart|status|checkup|console}"
    exit 1
esac
