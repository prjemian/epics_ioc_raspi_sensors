TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE
#=============================

# For Kate Feng's implementation of devScaler.c, which uses Till
# Straumann's basicIoOps.h to bridge any mismatch between endianness
# of Joerger scaler hardware and endianness of processor.
#USR_CFLAGS += -DHAS_IOOPS_H

#=============================
# build an ioc application

PROD_IOC = raspi

SHARED_LIBRARIES=YES
STATIC_BUILD=NO

# Note that the order in which .dbd files and libraries are added to a list
# variable is important.  For .dbd files, things must be defined before they
# are referenced by a later .dbd file.  For libraries, things must be referenced
# before they are searched for; otherwise they won't be included.

# Custom stuff in development

##################################################################
# First, define raspi_Common_DBD and raspi_Common_LIBS from the modules
# defined in RELEASE
##################################################################
DBD += raspi_Common.dbd
raspi_Common_DBD += base.dbd

#ifdef CAPUTLOG
#	raspi_Common_DBD += caPutLog.dbd
#	raspi_Common_LIBS := caPutLog $(raspi_Common_LIBS)
#endif

#ifdef CAPUTRECORDER
#	raspi_Common_DBD += caputRecorder.dbd
#	raspi_Common_LIBS := caputRecorder $(raspi_Common_LIBS)
#endif

ifdef SNCSEQ
    raspi_Common_LIBS += seq pv
    raspi_LIBS += seq pv

	# build DHT22 support in SNL
	raspi_SRCS += dht22.c
	raspi_SRCS += dht22_seq.st
    raspi_Common_DBD += dht22_seq.dbd

	USR_SYS_LIBS += wiringPi

#	ifeq (seq-2-1, $(findstring seq-2-1, $(SNCSEQ)))
#		raspi_Common_DBD += devSequencer.dbd
#		raspi_Common_LIBS := seqDev seq pv $(raspi_Common_LIBS)
#	else ifeq (seq-2.1, $(findstring seq-2.1, $(SNCSEQ)))
#		raspi_Common_DBD += devSequencer.dbd
#		raspi_Common_LIBS := seqDev seq pv $(raspi_Common_LIBS)
#	else
#		# seq 2.2.
#		#raspiSupport_LIBS += seq pv
#		raspi_LIBS += seq pv
#		raspi_Common_LIBS := seq pv $(raspi_Common_LIBS)

#		raspi_SRCS += dht22.c

#		raspi_SRCS += dht22_seq.st
#		raspi_DBD += dht22_seqSupport.dbd

#		USR_SYS_LIBS += wiringPi

#	endif
endif

#ifdef ASYN
#	raspi_Common_DBD += asyn.dbd drvAsynSerialPort.dbd
#	raspi_Common_DBD += drvAsynIPPort.dbd drvVxi11.dbd devGpib.dbd
#	raspi_Common_LIBS := asyn $(raspi_Common_LIBS)
#endif

ifdef STD
	raspi_Common_DBD += stdSupport.dbd
	raspi_Common_LIBS := std $(raspi_Common_LIBS)
endif

#ifdef CALC
#	raspi_Common_DBD += calcSupport.dbd
#	raspi_Common_LIBS := calc $(raspi_Common_LIBS)
#endif

#ifdef BUSY
#	raspi_Common_DBD += busySupport.dbd
#	raspi_Common_LIBS := busy $(raspi_Common_LIBS)
#endif

#ifdef SSCAN
#	raspi_Common_DBD += sscanSupport.dbd
#	raspi_Common_LIBS := sscan $(raspi_Common_LIBS)
#	ifdef SNCSEQ
#		raspi_Common_DBD += sscanProgressSupport.dbd
#		raspi_Common_LIBS := scanProgress $(raspi_Common_LIBS)
#	endif
#endif

ifdef AUTOSAVE
	raspi_Common_DBD += asSupport.dbd
	raspi_Common_LIBS := autosave $(raspi_Common_LIBS)
endif

#ifdef OPTICS
#	raspi_Common_DBD += opticsSupport.dbd
#	raspi_Common_LIBS := optics $(raspi_Common_LIBS)
#endif

#ifdef MCA
#	raspi_Common_DBD += mcaSupport.dbd
#	raspi_Common_LIBS := mca $(raspi_Common_LIBS)
#endif

#ifdef IP
#	raspi_Common_DBD += ipSupport.dbd
#	raspi_Common_LIBS := ip $(raspi_Common_LIBS)
#endif

#ifdef MODBUS
#	raspi_Common_DBD += modbusSupport.dbd
#	raspi_Common_LIBS := modbus $(raspi_Common_LIBS)
#endif

#ifdef MOTOR
#	raspi_Common_DBD += motorSupport.dbd 
#	#raspi_Common_DBD += devAcsMotor.dbd devAerotech.dbd
#	#raspi_Common_DBD += devAttocube.dbd devFaulhaberMotor.dbd devImsMotor.dbd
#	#raspi_Common_DBD += devKohzuMotor.dbd devMclennanMotor.dbd devMicos.dbd
#	#raspi_Common_DBD += devMicroMo.dbd devNewFocus.dbd devNewport.dbd
#	#raspi_Common_DBD += devOriel.dbd devPC6K.dbd devPIJena.dbd devPIMotor.dbd
#	#raspi_Common_DBD += devSPiiPlus.dbd devSmartMotorMotor.dbd 
#	#raspi_Common_DBD += devThorLabs.dbd 
#	raspi_Common_DBD += devSoftMotor.dbd
#	raspi_Common_DBD += motorSimSupport.dbd

#	raspi_Common_LIBS := motor $(raspi_Common_LIBS)
#	#raspi_Common_LIBS := Acs acsTech80 Aerotech $(raspi_Common_LIBS)
#	#raspi_Common_LIBS := Attocube Faulhaber Ims $(raspi_Common_LIBS)
#	#raspi_Common_LIBS := KohzuMotor Mclennan Micos $(raspi_Common_LIBS)
#	#raspi_Common_LIBS := MicroMo NewFocus Newport $(raspi_Common_LIBS)
#	#raspi_Common_LIBS := Oriel PI PIJena $(raspi_Common_LIBS)
#	#raspi_Common_LIBS := Parker $(raspi_Common_LIBS)
#	#raspi_Common_LIBS := SmartMotor $(raspi_Common_LIBS)
#	#raspi_Common_LIBS := ThorLabs $(raspi_Common_LIBS)
#	raspi_Common_LIBS := softMotor $(raspi_Common_LIBS)
#	raspi_Common_LIBS := motorSimSupport $(raspi_Common_LIBS)
#endif

#ifdef STREAM
#	raspi_Common_DBD += stream.dbd streamSynApps.dbd
#	raspi_Common_LIBS := stream streamSynApps $(raspi_Common_LIBS)
#endif

#ifdef DEVIOCSTATS
#  ifneq ($(OS_CLASS), WIN32)
#	raspi_Common_DBD += devIocStats.dbd iocAdmin.dbd
#	raspi_Common_LIBS := devIocStats $(raspi_Common_LIBS)
#  endif
#endif


#ifdef ALIVE
#	raspi_Common_DBD += aliveSupport.dbd
#	raspi_Common_LIBS := alive $(raspi_Common_LIBS)
#endif

raspi_Common_LIBS := $(raspi_Common_LIBS) $(EPICS_BASE_IOC_LIBS)

##################################################################


ifneq (,$(findstring linux, $(T_A)))
	DBD  += iocraspiLinux.dbd
	iocraspiLinux_DBD += raspi_Common.dbd

#	ifdef IPAC
#		iocraspiLinux_DBD += drvIpac.dbd
#		raspi_LIBS_Linux += Ipac
#	endif

endif

# <name>_registerRecordDeviceDriver.cpp will be created from <name>.dbd
raspi_SRCS_Linux    += iocraspiLinux_registerRecordDeviceDriver.cpp     raspiMain.cpp
raspi_LIBS_Linux    += $(raspi_Common_LIBS)


#===========================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE

$(COMMON_DIR)/iocraspiLinuxInclude.dbd: $(COMMON_DIR)/raspi_Common.dbd
$(COMMON_DIR)/iocraspiLinux.dbd: $(COMMON_DIR)/raspi_Common.dbd
iocraspiLinux.dbd$(DEP): $(COMMON_DIR)/raspi_Common.dbd
