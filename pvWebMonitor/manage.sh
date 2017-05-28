#!/bin/bash
# init file for pvWebMonitor
#
# chkconfig: - 98 98
# description: pvWebMonitor WWW page update script for NAME_YOUR_SYSTEM_HERE
#
# processname: pvWebMonitor_MAKE_THIS_NAME_UNIQUE


PROJECT_DIR=/usr/local/epics/ioc/raspi/pvWebMonitor
MANAGE=${PROJECT_DIR}/manage.sh
LOGFILE=${PROJECT_DIR}/log-manage.txt
PIDFILE=${PROJECT_DIR}/pid.txt
CONFIGFILE=${PROJECT_DIR}/config.xml
EXECUTABLE_SCRIPT=/usr/local/bin/pvWebMonitor
RETVAL=0


get_pid(){
    cd ${PROJECT_DIR}
    PID=`/bin/cat ${PIDFILE}`
    return $PID
}


check_pid_running(){
	get_pid
	if [ "${PID}" == "" ]; then
		# no PID in the PIDFILE
		RETVAL=1
	else
		RESPONSE=`ps -p ${PID} -o comm=`
		if [ "${RESPONSE}" == "pvWebMonitor" ]; then
			# PID matches the pvWebMonitor profile
			RETVAL=0
		else
			# PID is not pvWebMonitor
			RETVAL=1
		fi
	fi
	return $RETVAL
}


start(){
    cd ${PROJECT_DIR}
    ${EXECUTABLE_SCRIPT} ${CONFIGFILE} 2>&1 >> ${LOGFILE} &
    PID=$!
    /bin/echo ${PID} > ${PIDFILE}
    /bin/echo "# [$0 `/bin/date`] started ${PID}: ${EXECUTABLE_SCRIPT}" 2>&1 >> ${LOGFILE} &
    /bin/echo "# [$0 `/bin/date`] started ${PID}: ${EXECUTABLE_SCRIPT}"
}


stop(){
    get_pid
    check_pid_running
    
    if [ $RETVAL == 1 ]; then
		/bin/echo "# [$0 `/bin/date`] not running ${PID}: ${EXECUTABLE_SCRIPT}" 2>&1 >> ${LOGFILE} &
    else
    	kill ${PID}
    	/bin/echo "# [$0 `/bin/date`] stopped ${PID}: ${EXECUTABLE_SCRIPT}" 2>&1 >> ${LOGFILE} &
    	/bin/echo "# [$0 `/bin/date`] stopped ${PID}: ${EXECUTABLE_SCRIPT}"
    fi
    /bin/cp -f /dev/null ${PIDFILE}
}


restart(){
    stop
    start
}


checkup(){
    #=====================
    # call periodically (every 5 minutes) to see if pvWebMonitor is running
    #=====================
    #	     field	    allowed values
    #	   -----	  --------------
    #	   minute	  0-59
    #	   hour 	  0-23
    #	   day of month   1-31
    #	   month	  1-12 (or names, see below)
    #	   day of week    0-7 (0 or 7 is Sun, or use names)
    #
    # */5 * * * * /usr/local/epics/ioc/raspi/pvWebMonitor/manage.sh checkup 2>&1 > /dev/null


    get_pid
    check_pid_running
    if [ $RETVAL == 0 ]; then
		echo "# [$0 `/bin/date`] running fine, so it seems" 2>&1 > /dev/null
    else
		echo "# [$0 `/bin/date`] could not identify running process ${PID}, starting new process" 2>&1 >> ${LOGFILE}
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
  checkup)
    checkup
    ;;
  *)
    echo $"Usage: $0 {start|stop|restart|checkup}"
    exit 1
esac
