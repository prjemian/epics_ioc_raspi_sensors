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

ifdef CAPUTRECORDER
	raspi_Common_DBD += caputRecorder.dbd
	raspi_Common_LIBS := caputRecorder $(raspi_Common_LIBS)
endif

ifdef SNCSEQ
	ifeq (seq-2-1, $(findstring seq-2-1, $(SNCSEQ)))
		raspi_Common_DBD += devSequencer.dbd
		raspi_Common_LIBS := seqDev seq pv $(raspi_Common_LIBS)
	else ifeq (seq-2.1, $(findstring seq-2.1, $(SNCSEQ)))
		raspi_Common_DBD += devSequencer.dbd
		raspi_Common_LIBS := seqDev seq pv $(raspi_Common_LIBS)
	else
		# seq 2.2.
		raspi_Common_LIBS := seq pv $(raspi_Common_LIBS)
	endif
endif

ifdef ASYN
	raspi_Common_DBD += asyn.dbd drvAsynSerialPort.dbd
	raspi_Common_DBD += drvAsynIPPort.dbd drvVxi11.dbd devGpib.dbd
	raspi_Common_LIBS := asyn $(raspi_Common_LIBS)
endif

ifdef STD
	raspi_Common_DBD += stdSupport.dbd
	raspi_Common_LIBS := std $(raspi_Common_LIBS)
endif

ifdef CALC
	raspi_Common_DBD += calcSupport.dbd
	raspi_Common_LIBS := calc $(raspi_Common_LIBS)
endif

ifdef BUSY
	raspi_Common_DBD += busySupport.dbd
	raspi_Common_LIBS := busy $(raspi_Common_LIBS)
endif

ifdef SSCAN
	raspi_Common_DBD += sscanSupport.dbd
	raspi_Common_LIBS := sscan $(raspi_Common_LIBS)
	ifdef SNCSEQ
		raspi_Common_DBD += sscanProgressSupport.dbd
		raspi_Common_LIBS := scanProgress $(raspi_Common_LIBS)
	endif
endif

ifdef AUTOSAVE
	raspi_Common_DBD += asSupport.dbd
	raspi_Common_LIBS := autosave $(raspi_Common_LIBS)
endif

ifdef OPTICS
	raspi_Common_DBD += opticsSupport.dbd
	raspi_Common_LIBS := optics $(raspi_Common_LIBS)
endif

ifdef MCA
	raspi_Common_DBD += mcaSupport.dbd
	raspi_Common_LIBS := mca $(raspi_Common_LIBS)
endif

ifdef IP
	raspi_Common_DBD += ipSupport.dbd
	raspi_Common_LIBS := ip $(raspi_Common_LIBS)
endif

ifdef MODBUS
	raspi_Common_DBD += modbusSupport.dbd
	raspi_Common_LIBS := modbus $(raspi_Common_LIBS)
endif

ifdef MOTOR
	raspi_Common_DBD += motorSupport.dbd devAcsMotor.dbd devAerotech.dbd
	raspi_Common_DBD += devAttocube.dbd devFaulhaberMotor.dbd devImsMotor.dbd
	raspi_Common_DBD += devKohzuMotor.dbd devMclennanMotor.dbd devMicos.dbd
	raspi_Common_DBD += devMicroMo.dbd devNewFocus.dbd devNewport.dbd
	raspi_Common_DBD += devOriel.dbd devPC6K.dbd devPIJena.dbd devPIMotor.dbd
	raspi_Common_DBD += devSPiiPlus.dbd devSmartMotorMotor.dbd devSoftMotor.dbd
	raspi_Common_DBD += devThorLabs.dbd motorSimSupport.dbd

	raspi_Common_LIBS := motor $(raspi_Common_LIBS)
	raspi_Common_LIBS := Acs acsTech80 Aerotech Attocube Faulhaber Ims KohzuMotor $(raspi_Common_LIBS)
	raspi_Common_LIBS := Mclennan Micos MicroMo NewFocus Newport Oriel PI PIJena $(raspi_Common_LIBS)
	raspi_Common_LIBS := Parker SmartMotor ThorLabs softMotor motorSimSupport $(raspi_Common_LIBS)
endif

ifdef STREAM
	raspi_Common_DBD += stream.dbd streamSynApps.dbd
	raspi_Common_LIBS := stream streamSynApps $(raspi_Common_LIBS)
endif

ifdef DEVIOCSTATS
  ifneq ($(OS_CLASS), WIN32)
	raspi_Common_DBD += devIocStats.dbd iocAdmin.dbd
	raspi_Common_LIBS := devIocStats $(raspi_Common_LIBS)
  endif
endif

ifdef ETHERIP
	raspi_Common_DBD += ether_ip.dbd
	raspi_Common_LIBS := ether_ip $(raspi_Common_LIBS)
endif

ifdef ALIVE
	raspi_Common_DBD += aliveSupport.dbd
	raspi_Common_LIBS := alive $(raspi_Common_LIBS)
endif

ifdef DELAYGEN
	raspi_Common_DBD += delaygenSupport.dbd
	raspi_Common_LIBS := delaygen $(raspi_Common_LIBS)
endif

ifdef VAC
	raspi_Common_DBD += vacSupport.dbd
	raspi_Common_LIBS := vac $(raspi_Common_LIBS)
endif

raspi_Common_LIBS := $(raspi_Common_LIBS) $(EPICS_BASE_IOC_LIBS)

##################################################################


ifeq (win32-x86,$(findstring win32-x86, $(T_A)))

	DBD  += iocraspiWin32.dbd
	iocraspiWin32_DBD += raspi_Common.dbd

	ifdef MCA
		# If your host supports libpcap and libnet and you want to build
		# Canberra network support uncomment the following lines
		#iocraspiWin32_DBD += mcaCanberraSupport.dbd
		#raspi_LIBS_WIN32 += mcaCanberra
		#raspi_LIBS_WIN32 += wpcap Packet
	endif

	ifdef DXP
		# If you want to build parallel port or USB interfaces to Saturn and/or
		# xMAP DXP, then uncomment the following lines
		iocraspiWin32_DBD += dxpSupport.dbd
		raspi_LIBS_WIN32 += dxp handel
		raspi_LIBS_WIN32 += DLPORTIO PlxApi
		raspi_SYS_LIBS_WIN32 += setupapi
	endif

endif

ifeq (windows-x64,$(findstring windows-x64, $(T_A)))
	DBD  += iocraspiWin64.dbd
	iocraspiWin64_DBD += raspi_Common.dbd

	ifdef MCA
		# If your host supports libpcap and libnet and you want to build Canberra network
		# support uncomment the following line
		iocraspiWin64_DBD += mcaCanberraSupport.dbd
		raspi_LIBS_WIN32 += mcaCanberra
		raspi_LIBS_WIN32 += wpcap Packet
	endif

endif

ifeq ($(EPICS_HOST_ARCH), cygwin-x86)
	DBD  += iocraspiCygwin.dbd
	iocraspiCygwin_DBD += raspi_Common.dbd

	ifdef DXP
		# If you want to build parallel port or USB interfaces to Saturn and/or
		# xMAP DXP,then uncomment the following lines
		#iocraspiCygwin_DBD += dxpSupport.dbd
		#raspi_LIBS_cygwin32 += dxp handel
		#raspi_SYS_LIBS_cygwin32 += DLPORTIO PlxApi setupapi
	endif

	raspi_SYS_LIBS_cygwin32 += $(CYGWIN_RPC_LIB)

endif

ifeq (vxWorks,$(findstring vxWorks, $(T_A)))
	DBD  += iocraspiVX.dbd
	iocraspiVX_DBD += raspi_Common.dbd

	ifdef ALLEN_BRADLEY
		raspi_LIBS_vxWorks += allenBradley
	endif

	ifdef QUADEM
		iocraspiVX_DBD += drvAHxxx.dbd
		iocraspiVX_DBD += drvAPS_EM.dbd
		raspi_LIBS_vxWorks += quadEM
	endif

	ifdef AREA_DETECTOR
		# areaDetector provides a Makefile for things it needs and supplies
		PROD_NAME = AD
		-include $(ADCORE)/ADApp/commonDriverMakefile
		iocraspiVX_DBD += ADSupport.dbd NDPluginSupport.dbd
		raspi_LIBS_vxWorks += $(AD_LIBS)
		# To add the simDetector uncomment the following lines
		iocraspiVX_DBD += simDetectorSupport.dbd
		raspi_LIBS_vxWorks += simDetector
	endif

	ifdef VME
		iocraspiVX_DBD += vmeVXSupport.dbd
		raspi_LIBS_vxWorks += vme
	endif

	ifdef STD
		iocraspiVX_DBD += stdVXSupport.dbd
	endif

	ifdef IP
		iocraspiVX_DBD += ipVXSupport.dbd
	endif

	ifdef MCA
		iocraspiVX_DBD += SIS38XXSupport.dbd
		iocraspiVX_DBD += mcaCanberraSupport.dbd
		raspi_LIBS_vxWorks += SIS38XX
		raspi_LIBS_vxWorks += mcaCanberra
	endif

	ifdef IPUNIDIG
		iocraspiVX_DBD += ipUnidigSupport.dbd
		raspi_LIBS_vxWorks += ipUnidig
	endif

	ifdef DAC128V
		iocraspiVX_DBD += dac128VSupport.dbd
		raspi_LIBS_vxWorks += dac128V
	endif

	ifdef IP330
		iocraspiVX_DBD += ip330Support.dbd
		raspi_LIBS_vxWorks += ip330
	endif

	ifdef CAMAC
		iocraspiVX_DBD += camacSupport.dbd
		iocraspiVX_DBD += devCamacSupport.dbd
		raspi_LIBS_vxWorks += camac devCamac
	endif

	ifdef ALLEN_BRADLEY
		iocraspiVX_DBD += allenBradley.dbd
	endif

	ifdef LOVE
		iocraspiVX_DBD += devLove.dbd
		raspi_LIBS_vxWorks += love
	endif

	ifdef IPAC
		iocraspiVX_DBD += tyGSOctal.dbd
		iocraspiVX_DBD += drvIpac.dbd
		raspi_LIBS_vxWorks += TyGSOctal Ipac
	endif

	ifdef ASYN
		iocraspiVX_DBD += drvGsIP488.dbd
	endif

	ifdef SOFTGLUE
		iocraspiVX_DBD += softGlueSupport.dbd
		raspi_LIBS_vxWorks += softGlue
	endif

	ifdef MOTOR
		iocraspiVX_DBD += devDeltaTau.dbd
		iocraspiVX_DBD += devOms.dbd
		raspi_LIBS_vxWorks += oms DeltaTau
	endif

	ifdef DEVIOCSTATS
		iocraspiVX_DBD += devVxStats.dbd
	endif
endif

ifneq (,$(findstring linux, $(T_A)))
	DBD  += iocraspiLinux.dbd
	iocraspiLinux_DBD += raspi_Common.dbd

ifeq ($(HAVE_HDF5), YES)
ifeq ($(HAVE_SZIP), YES)

	ifdef QUADEM
		iocraspiLinux_DBD += drvAHxxx.dbd
		raspi_LIBS_Linux += quadEM
	endif

	ifdef AREA_DETECTOR
		# areaDetector provides a Makefile for things it needs and supplies
		PROD_NAME = AD
		-include $(ADCORE)/ADApp/commonDriverMakefile
		iocraspiLinux_DBD += ADSupport.dbd NDPluginSupport.dbd
		raspi_LIBS_Linux += $(AD_LIBS)
		# To add the simDetector uncomment the following lines
		iocraspiLinux_DBD += simDetectorSupport.dbd
		raspi_LIBS_Linux += simDetector
	endif

	ifdef DXP
		# If your host supports parallel port or USB interfaces to Saturn DXP, set
		# LINUX_USB_INSTALLED to YES in <synApps>/configure/CONFIG_SITE.
		ifeq ($(LINUX_USB_INSTALLED), YES)
			iocraspiLinux_DBD += dxpSupport.dbd
			raspi_LIBS_Linux  += dxp handel
			raspi_SYS_LIBS_Linux += usb
		endif
	endif

endif
endif

	ifdef MCA
		# If your host supports libpcap and libnet and you want to build Canberra network
		# support, set LINUX_NET_INSTALLED to YES in <synApps>/configure/CONFIG_SITE.
		ifeq ($(LINUX_NET_INSTALLED), YES)
			iocraspiLinux_DBD += mcaCanberraSupport.dbd
			raspi_LIBS_Linux += mcaCanberra
			raspi_SYS_LIBS_Linux += net pcap
		endif
	endif

	ifdef IPAC
		iocraspiLinux_DBD += drvIpac.dbd
		raspi_LIBS_Linux += Ipac
	endif

	ifdef SOFTGLUE
		iocraspiLinux_DBD += softGlueSupport.dbd
		raspi_LIBS_Linux += softGlue
	endif
endif

ifeq ($(OS_CLASS), Darwin)
	DBD  += iocraspiDarwin.dbd
	iocraspiDarwin_DBD += raspi_Common.dbd
endif



# <name>_registerRecordDeviceDriver.cpp will be created from <name>.dbd
raspi_SRCS_vxWorks  += iocraspiVX_registerRecordDeviceDriver.cpp
raspi_SRCS_Linux    += iocraspiLinux_registerRecordDeviceDriver.cpp     raspiMain.cpp
ifeq (win32-x86,$(findstring win32-x86, $(T_A)))
	raspi_SRCS_WIN32    += iocraspiWin32_registerRecordDeviceDriver.cpp     raspiMain.cpp
endif
ifeq (windows-x64,$(findstring windows-x64, $(T_A)))
	raspi_SRCS_WIN32    += iocraspiWin64_registerRecordDeviceDriver.cpp     raspiMain.cpp
endif
raspi_SRCS_cygwin32 += iocraspiCygwin_registerRecordDeviceDriver.cpp    raspiMain.cpp
raspi_SRCS_solaris  += iocraspi_solaris_registerRecordDeviceDriver.cpp  raspiMain.cpp
raspi_SRCS_Darwin   += iocraspiDarwin_registerRecordDeviceDriver.cpp    raspiMain.cpp



#The following adds support from base/src/vxWorks
raspi_OBJS_vxWorks += $(EPICS_BASE_BIN)/vxComLibrary

raspi_LIBS_vxWorks  += $(raspi_Common_LIBS)
raspi_LIBS_Linux    += $(raspi_Common_LIBS)
raspi_LIBS_solaris  += $(raspi_Common_LIBS)
raspi_LIBS_cygwin32 += $(raspi_Common_LIBS)
raspi_LIBS_WIN32    += $(raspi_Common_LIBS)
raspi_LIBS_Darwin   += $(raspi_Common_LIBS)


#===========================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE

$(COMMON_DIR)/iocraspiWin32Include.dbd: $(COMMON_DIR)/raspi_Common.dbd
$(COMMON_DIR)/iocraspiWin64Include.dbd: $(COMMON_DIR)/raspi_Common.dbd
$(COMMON_DIR)/iocraspiCygwinInclude.dbd: $(COMMON_DIR)/raspi_Common.dbd
$(COMMON_DIR)/iocraspiVXInclude.dbd: $(COMMON_DIR)/raspi_Common.dbd
$(COMMON_DIR)/iocraspiLinuxInclude.dbd: $(COMMON_DIR)/raspi_Common.dbd
$(COMMON_DIR)/iocraspiDarwinInclude.dbd: $(COMMON_DIR)/raspi_Common.dbd

$(COMMON_DIR)/iocraspiWin32.dbd: $(COMMON_DIR)/raspi_Common.dbd
$(COMMON_DIR)/iocraspiWin64.dbd: $(COMMON_DIR)/raspi_Common.dbd
$(COMMON_DIR)/iocraspiCygwin.dbd: $(COMMON_DIR)/raspi_Common.dbd
$(COMMON_DIR)/iocraspiVX.dbd: $(COMMON_DIR)/raspi_Common.dbd
$(COMMON_DIR)/iocraspiLinux.dbd: $(COMMON_DIR)/raspi_Common.dbd
$(COMMON_DIR)/iocraspiDarwin.dbd: $(COMMON_DIR)/raspi_Common.dbd

iocraspiWin32.dbd$(DEP): $(COMMON_DIR)/raspi_Common.dbd
iocraspiWin64.dbd$(DEP): $(COMMON_DIR)/raspi_Common.dbd
iocraspiCygwin.dbd$(DEP): $(COMMON_DIR)/raspi_Common.dbd
iocraspiVX.dbd$(DEP): $(COMMON_DIR)/raspi_Common.dbd
iocraspiLinux.dbd$(DEP): $(COMMON_DIR)/raspi_Common.dbd
iocraspiDarwin.dbd$(DEP): $(COMMON_DIR)/raspi_Common.dbd

raspi_SRCS += dht22.c
raspi_LIBS += wiringPi
raspi_SRCS += dht22_seq.st
