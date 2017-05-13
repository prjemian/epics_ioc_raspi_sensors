# Linux startup script

# For devIocStats
epicsEnvSet("ENGINEER","Raspberry Pi")
epicsEnvSet("LOCATION","LAN")
epicsEnvSet("GROUP","raspi")

< envPaths

# save_restore.cmd needs the full path to the startup directory, which
# envPaths currently does not provide
epicsEnvSet(STARTUP,$(TOP)/iocBoot/$(IOC))

# Increase size of buffer for error logging from default 1256
errlogInit(20000)

# Specify largest array CA will transport
# Note for N doubles, need N*8 bytes+some overhead
epicsEnvSet EPICS_CA_MAX_ARRAY_BYTES 64010

################################################################################
# Tell EPICS all about the record types, device-support modules, drivers,
# etc. in the software we just loaded (raspi.munch)
dbLoadDatabase("../../dbd/iocraspiLinux.dbd")
iocraspiLinux_registerRecordDeviceDriver(pdbbase)

### save_restore setup
< save_restore.cmd

# Access Security
dbLoadRecords("$(TOP)/raspiApp/Db/Security_Control.db","P=raspi:")
asSetFilename("$(TOP)/iocBoot/accessSecurity.acf")
asSetSubstitutions("P=raspi:")


# soft scaler for testing
< softScaler.cmd

# user-assignable ramp/tweak
dbLoadRecords("$(STD)/stdApp/Db/ramp_tweak.db","P=raspi:,Q=rt1")

# serial support
#< serial.cmd

# Motors
#dbLoadTemplate("basic_motor.substitutions")
#dbLoadTemplate("motor.substitutions")
dbLoadTemplate("softMotor.substitutions")
dbLoadTemplate("pseudoMotor.substitutions")
< motorSim.cmd
# motorUtil (allstop & alldone)
dbLoadRecords("$(MOTOR)/db/motorUtil.db", "P=raspi:")
# Run this after iocInit:
doAfterIocInit("motorUtilInit('raspi:')")

### Scan-support software
# crate-resident scan.  This executes 1D, 2D, 3D, and 4D scans, and caches
# 1D data, but it doesn't store anything to disk.  (See 'saveData' below for that.)
dbLoadRecords("$(SSCAN)/sscanApp/Db/standardScans.db","P=raspi:,MAXPTS1=1000,MAXPTS2=1000,MAXPTS3=1000,MAXPTS4=1000,MAXPTSH=1000")
dbLoadRecords("$(SSCAN)/sscanApp/Db/saveData.db","P=raspi:")
# Run this after iocInit:
#doAfterIocInit("saveData_Init(saveData.req, 'P=raspi:')")
#dbLoadRecords("$(SSCAN)/sscanApp/Db/scanProgress.db","P=raspi:scanProgress:")
# Run this after iocInit:
#doAfterIocInit("seq &scanProgress, 'S=raspi:, P=raspi:scanProgress:'")

# configMenu example.
dbLoadRecords("$(AUTOSAVE)/asApp/Db/configMenu.db","P=raspi:,CONFIG=scan1")
# Note that the request file MUST be named $(CONFIG)Menu.req
# If the macro CONFIGMENU is defined with any value, backup (".savB") and
# sequence files (".savN") will not be written.  We don't want these for configMenu.
# Run this after iocInit:
doAfterIocInit("create_manual_set('scan1Menu.req','P=raspi:,CONFIG=scan1,CONFIGMENU=1')")
# You could make scan configurations read-only:
#dbLoadRecords("$(AUTOSAVE)/asApp/Db/configMenu.db","P=raspi:,CONFIG=scan1,ENABLE_SAVE=0")

# read-only configMenu example.  (Read-only, because we're not calling create_manual_set().)
#dbLoadRecords("$(AUTOSAVE)/asApp/Db/configMenu.db","P=raspi:,CONFIG=scan2")

# A set of scan parameters for each positioner.  This is a convenience
# for the user.  It can contain an entry for each scannable thing in the
# crate.
dbLoadTemplate("scanParms.substitutions")



### Optical tables
#dbLoadRecords("$(OPTICS)/opticsApp/Db/table.db","P=raspi:,Q=Table1,T=table1,M0X=m1,M0Y=m2,M1Y=m3,M2X=m4,M2Y=m5,M2Z=m6,GEOM=SRI")
dbLoadRecords("$(OPTICS)/opticsApp/Db/table.db","P=raspi:,Q=Table1,T=table1,M0X=m1,M0Y=m2,M1Y=m3,M2X=m4,M2Y=m5,M2Z=m6,GEOM=NEWPORT")
#dbLoadRecords("$(OPTICS)/opticsApp/Db/table.db","P=raspi:,Q=Table2,T=table2,M0X=m1,M0Y=m2,M1Y=m3,M2X=m4,M2Y=m5,M2Z=m6,GEOM=SRI")


### Stuff for user programming ###
< calc.cmd

# Slow feedback
dbLoadTemplate "pid_slow.substitutions"
dbLoadTemplate "async_pid_slow.substitutions"

# Miscellaneous PV's, such as burtResult
dbLoadRecords("$(STD)/stdApp/Db/misc.db","P=raspi:")

# devIocStats
dbLoadRecords("$(DEVIOCSTATS)/db/iocAdminSoft.db","IOC=raspi")

# DHT22 humidity & temperature sensor on wiringPi pin 0
dbLoadRecords("dht22.db","P=raspi:,C=0")
doAfterIocInit("seq &dht22_seq, 'name=dht22_0,P=raspi:,C=0'")

###############################################################################
iocInit
###############################################################################

# write all the PV names to a local file
dbl > dbl-all.txt

# Report  states of database CA links
dbcar(*,1)

# print the time our boot was finished
date

