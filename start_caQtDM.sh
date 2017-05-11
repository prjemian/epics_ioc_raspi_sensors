#!/bin/bash

export EPICS_APP=/usr/local/epics/ioc/raspi
export EPICS_APP_UI_DIR=${EPICS_APP}/raspiApp/op/ui


#######################################
# support function to simplify repetitive task,
# used to build up displaty path of supported modules
#
# usage::
#
#    addModule ENVIRONMENT_VARIABLE [SUBDIRECTORY]
#
# QTDMDP is temporary CAQTDM_DISPLAY_PATH
# QTDMDP is internal to this script, no need to export.

function addModule
{
    # $1 is a symbol defined in <synApps>/configure/RELEASE
    # module_path is the path defined for that symbol in the RELEASE file
    module='$'$1
    module_path=`eval echo $module`
    if [ "" != "${module}" ]; then
      if [ "" == "${QTDMDP}" ]; then
        QTDMDP=.
      fi
      QTDMDP=${QTDMDP}:${module_path}
      if [ "" != "$2" ]; then
        QTDMDP=${QTDMDP}/$2
      fi
    fi
}

#######################################
# get environment variables for support modules 

output=`perl -s $EPICS_APP/release.pl -form=bash  $EPICS_APP`
eval $output

#######################################
# add support for modules defined by environment variables
# modules are *appended* to the growing list of directories

# ========  ================  ===========================
# function  MODULE_VARIABLE   subdirectory with .ui files
# ========  ================  ===========================
addModule   EPICS_APP_UI_DIR
addModule   ALIVE             ./aliveApp/op/ui
addModule   AREA_DETECTOR     ./ADCore/ADApp/op/ui
addModule   AREA_DETECTOR     ./ADCore/ADApp/op/ui/autoconvert
addModule   ASYN	      ./opi/caqtdm
addModule   AUTOSAVE	      ./asApp/op/ui
addModule   BUSY	      ./busyApp/op/ui
addModule   CALC	      ./calcApp/op/ui
addModule   CAMAC	      ./camacApp/op/ui
addModule   CAPUTRECORDER     ./caputRecorderApp/op/ui
addModule   DAC128V	      ./dac128VApp/op/ui
addModule   DELAYGEN	      ./delaygenApp/op/ui
addModule   DEVIOCSTATS       ./op/ui
addModule   DXP 	      ./dxpApp/op/ui
addModule   IP  	      ./ipApp/op/ui
addModule   IP330	      ./ip330App/op/ui
addModule   IPUNIDIG	      ./ipUnidigApp/op/ui
addModule   LOVE	      ./loveApp/op/ui
addModule   MCA 	      ./mcaApp/op/ui
addModule   MODBUS	      ./modbusApp/op/ui
addModule   MOTOR	      ./motorApp/op/ui
addModule   OPTICS	      ./opticsApp/op/ui
addModule   QUADEM	      ./quadEMApp/op/ui
addModule   SOFTGLUE	      ./softGlueApp/op/ui
addModule   SSCAN	      ./sscanApp/op/ui
addModule   STD 	      ./stdApp/op/ui
addModule   VAC 	      ./vacApp/op/ui
addModule   VME 	      ./vmeApp/op/ui
# ========  ================  ===========================


#######################################
# optional: add support directories not associated with environment variables

# QTDMDP=${QTDMDP}:/APSshare/uisys/sr/id


#######################################
# Define CAQTDM_DISPLAY_PATH
# the .ui file directory list for caQtDM

if [ "" == "${CAQTDM_DISPLAY_PATH}" ]; then
  export CAQTDM_DISPLAY_PATH=${QTDMDP}
else
  # either: pre-pend to display path
  export CAQTDM_DISPLAY_PATH=${QTDMDP}:${CAQTDM_DISPLAY_PATH}

  # or: append to display path
  #export CAQTDM_DISPLAY_PATH=${CAQTDM_DISPLAY_PATH}:${QTDMDP}
fi


#######################################
# optional: support for PVs with large data sizes, such as areaDetector
# This should agree with the environment variable set by the ioc
# see 'putenv "EPICS_CA_MAX_ARRAY_BYTES=64008"' in iocBoot/ioc<target>/st.cmd

if [ "" == "${EPICS_CA_MAX_ARRAY_BYTES}" ]; then
  #export EPICS_CA_MAX_ARRAY_BYTES=64008
  export EPICS_CA_MAX_ARRAY_BYTES=8000100
fi

#######################################
# optional: execute caQtDM in this support's ui directory

cd ${EPICS_APP_UI_DIR}


#######################################
# optional: override system default environment variables for Qt and Qwt
# These override system defaults for Qt, Qwt
# Because I'm using a local copy of Qt/Qwt, and not the system
# copy, I need to set some environment variables

#OVERRIDE_QT_BASE=/home/oxygen/MOONEY/Download/Qt
#export QTDIR=${OVERRIDE_QT_BASE}/qt-4.8.4
#export QT_PLUGIN_PATH=
#export QT_PLUGIN_PATH=${QT_PLUGIN_PATH}:${OVERRIDE_QT_BASE}/qt-4.8.4/plugins
#export QT_PLUGIN_PATH=${QT_PLUGIN_PATH}:${OVERRIDE_QT_BASE}/qwt-6.0/designer/plugins/designer


#######################################
# optional: other environment variables that may need local definitions
# these are copied from caQtDM's source for startDM_Local

#export QTCONTROLS_LIBS=`pwd`/caQtDM_Binaries
#export QTBASE=${QTCONTROLS_LIBS}
#export QT_PLUGIN_PATH=${QTBASE}
#export CAQTDM_DISPLAY_PATH=`pwd`/caQtDM_Tests

export MEDM_EXEC_LIST=
# For drag-and-drop workaround at APS, need /APSshare/bin/xclip
export PATH=${PATH}:/APSshare/bin
export CAQTDM_EXEC_LIST='Probe;probe &P &:UI File;echo &A:PV Name(s);echo &P:Copy PV name; echo -n &P| xclip -i -sel clip:Paste PV name;caput &P `xclip -o -sel clip`'

export START_PUTRECORDER=${EPICS_APP}/start_putrecorder
export MACROS_PY=${EPICS_APP_UI_DIR}/../python/macros.py
export EDITOR=nedit
export QT_PLUGIN_PATH=/APSshare/caqtdm/plugins
export LD_LIBRARY_PATH=/APSshare/caqtdm/lib
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/APSshare/epics/base-3.14.12.3/lib/linux-x86_64


#######################################
# optional: access to ioctim and bcdapc15

#export EPICS_CA_ADDR_LIST="164.54.53.99 164.54.54.88"


#######################################
# start caQtDM
#caQtDM -noMsg raspi.ui &
caQtDM -style plastique -noMsg raspi.ui &
