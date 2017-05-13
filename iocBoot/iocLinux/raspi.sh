#!/bin/sh
#
# description: start/stop/restart an EPICS IOC in a screen session
#

# Manually set IOC_STARTUP_DIR if raspi.sh will reside somewhere other than iocraspi
#!IOC_STARTUP_DIR=/home/username/epics/ioc/synApps/raspi/iocBoot/iocraspi
IOC_NAME=raspi

# Commands needed by this script
ECHO=echo
ID=id
PGREP=pgrep
SCREEN=screen
KILL=kill
BASENAME=basename
DIRNAME=dirname
# Explicitly define paths to commands if commands aren't found
#!ECHO=/bin/echo
#!ID=/usr/bin/id
#!PGREP=/usr/bin/pgrep
#!SCREEN=/usr/bin/screen
#!KILL=/bin/kill
#!BASENAME=/bin/basename
#!DIRNAME=/usr/bin/dirname

#####################################################################

SNAME=$0
SELECTION=$1

if [ -z "$IOC_STARTUP_DIR" ]
then
    # If no startup dir is specified, assume this script resides in the IOC's startup directory
    IOC_STARTUP_DIR="$(${DIRNAME} ${SNAME})"
fi
#!${ECHO} ${IOC_STARTUP_DIR}

#####################################################################

checkpid() {
    MY_UID=`${ID} -u`
    MY_UID=0
    # The '\$' is needed in the pgrep pattern to select raspi, but not raspi.sh
    IOC_PID=`${PGREP} ${IOC_NAME}\$ -u ${MY_UID}`
    #!echo "IOC_PID=${IOC_PID}"
    if [ "$IOC_PID" != "" ] ; then
        # IOC is running
        IOC_DOWN=0
    else
        # IOC is not running
	IOC_DOWN=1
    fi
    return ${IOC_DOWN}
}

start() {
    if checkpid; then
        ${ECHO} "${IOC_NAME} is already running (pid=${IOC_PID})"
    else
        ${ECHO} "Starting ${IOC_NAME}"
        cd ${IOC_STARTUP_DIR}
	./in-screen.sh
	# Run raspi outside of a screen session, which is helpful for debugging
	#!./run
    fi
}

stop() {
    if checkpid; then
        ${ECHO} "Stopping ${IOC_NAME} (pid=${IOC_PID})"
	sudo ${KILL} ${IOC_PID}
    else
        ${ECHO} "${IOC_NAME} is not running"
    fi
}

restart() {
    stop
    start
}

status() {
    if checkpid; then
        ${ECHO} "${IOC_NAME} is running (pid=${IOC_PID})"
    else
        ${ECHO} "${IOC_NAME} is not running"
    fi
}

console() {
    if checkpid; then
        ${ECHO} "Connecting to ${IOC_NAME}'s screen session"
	# The -r flag will only connect if no one is attached to the session
	#!${SCREEN} -r ${IOC_NAME}
	# The -x flag will connect even if someone is attached to the session
	${SCREEN} -x ${IOC_NAME}
    else
        ${ECHO} "${IOC_NAME} is not running"
    fi
}

usage() {
    ${ECHO} "Usage: $(${BASENAME} ${SNAME}) {start|stop|restart|status|console}"
}

#####################################################################

if [ ! -d ${IOC_STARTUP_DIR} ]
then
    ${ECHO} "Error: ${IOC_STARTUP_DIR} doesn't exist."
    ${ECHO} "IOC_STARTUP_DIR in ${SNAME} needs to be corrected."
else
    case ${SELECTION} in
        start)
	    start
	    ;;

        stop | kill)
	    stop
	    ;;

        restart)
	    restart
	    ;;

        status)
	    status
	    ;;
	
        console)
            console
	    ;;

        *)
	    usage
	    ;;
    esac
fi
