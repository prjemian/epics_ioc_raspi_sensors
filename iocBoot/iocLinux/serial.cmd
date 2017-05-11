
# BEGIN serial.cmd ------------------------------------------------------------

# Set up 2 local serial ports

# serial 1 connected to Keithley2K DMM at 19200 baud
#drvAsynSerialPortConfigure("portName","ttyName",priority,noAutoConnect,
#                            noProcessEos)
drvAsynSerialPortConfigure("serial1", "/dev/ttyS0", 0, 0, 0)
asynSetOption(serial1,0,baud,19200)
#asynOctetSetInputEos(const char *portName, int addr,
#                     const char *eosin,const char *drvInfo)
asynOctetSetInputEos("serial1",0,"\r\n")
# asynOctetSetOutputEos(const char *portName, int addr,
#                       const char *eosin,const char *drvInfo)
asynOctetSetOutputEos("serial1",0,"\r")
# Make port available from the iocsh command line
#asynOctetConnect(const char *entry, const char *port, int addr,
#                 int timeout, int buffer_len, const char *drvInfo)
asynOctetConnect("serial1", "serial1")

# serial 2 connected to Newport MM4000 at 38400 baud
drvAsynSerialPortConfigure("serial2", "/dev/ttyS1", 0, 0, 0)
asynSetOption(serial2,0,baud,38400)
asynOctetConnect("serial2", "serial2")
asynOctetSetInputEos("serial2",0,"\r")
asynOctetSetOutputEos("serial2",0,"\r")

# Set up ports 1 and 2 on Moxa box

# serial 3 is connected to the ACS MCB-4B at 9600 baud
#drvAsynIPPortConfigure("portName","hostInfo",priority,noAutoConnect,
#                        noProcessEos)
#drvAsynIPPortConfigure("serial3", "164.54.160.50:4001", 0, 0, 0)
#asynOctetConnect("serial3", "serial3")
#asynOctetSetInputEos("serial3",0,"\r")
# For Digitel need to use null input terminator
#asynOctetSetInputEos("serial3",0,"")
#asynOctetSetOutputEos("serial3",0,"\r")

# serial 4 not connected for now
#drvAsynIPPortConfigure("serial4", "164.54.160.50:4002", 0, 0, 0)
#asynOctetConnect("serial4", "serial4")
#asynOctetSetInputEos("serial4",0,"\r")
#asynOctetSetOutputEos("serial4",0,"\r")

# Newport MM4000 driver setup parameters:
#     (1) maximum # of controllers,
#     (2) motor task polling rate (min=1Hz, max=60Hz)
MM4000Setup(1, 10)

# Newport MM4000 driver configuration parameters:
#     (1) controller
#     (2) asyn port name (e.g. serial1 or gpib1)
#     (3) GPIB address (0 for serial)
MM4000Config(0, "serial2", 0)

# Newport PM500 driver setup parameters:
#     (1) maximum number of controllers in system
#     (2) motor task polling rate (min=1Hz,max=60Hz)
#PM500Setup(1, 10)

# Newport PM500 configuration parameters:
#     (1) controller
#     (2) asyn port name (e.g. serial1 or gpib1)
#PM500Config(0, "serial3")

# McClennan PM304 driver setup parameters:
#     (1) maximum number of controllers in system
#     (2) motor task polling rate (min=1Hz, max=60Hz)
#PM304Setup(1, 10)

# McClennan PM304 driver configuration parameters:
#     (1) controller being configured
#     (2) MPF serial server name (string)
#     (3) Number of axes on this controller
#PM304Config(0, "serial4", 1)

# ACS MCB-4B driver setup parameters:
#     (1) maximum number of controllers in system
#     (2) motor task polling rate (min=1Hz, max=60Hz)
MCB4BSetup(1, 10)

# ACS MCB-4B driver configuration parameters:
#     (1) controller being configured
#     (2) asyn port name (string)
MCB4BConfig(0, "serial3")

# Load asynRecord records on all ports
dbLoadTemplate("asynRecord.substitutions")

# send impromptu message to serial device, parse reply
# (was serial_OI_block)
dbLoadRecords("$(IP)/ipApp/Db/deviceCmdReply.db","P=raspi:,N=1,PORT=serial1,ADDR=0,OMAX=100,IMAX=100")
dbLoadRecords("$(IP)/ipApp/Db/deviceCmdReply.db","P=raspi:,N=2,PORT=serial2,ADDR=0,OMAX=100,IMAX=100")
dbLoadRecords("$(IP)/ipApp/Db/deviceCmdReply.db","P=raspi:,N=3,PORT=serial3,ADDR=0,OMAX=100,IMAX=100")

# Stanford Research Systems SR570 Current Preamplifier
#dbLoadRecords("$(IP)/ipApp/Db/SR570.db", "P=raspi:,A=A1,PORT=serial1")

# Lakeshore DRC-93CA Temperature Controller
#dbLoadRecords("$(IP)/ipApp/Db/LakeShoreDRC-93CA.db", "P=raspi:,Q=TC1,PORT=serial4")

# Huber DMC9200 DC Motor Controller
#dbLoadRecords("$(IP)/ipApp/Db/HuberDMC9200.db", "P=raspi:,Q=DMC1:,PORT=serial5")

# Oriel 18011 Encoder Mike
#dbLoadRecords("$(IP)/ipApp/Db/eMike.db", "P=raspi:,M=em1,PORT=serial3")

# Keithley 2000 DMM
#dbLoadRecords("$(IP)/ipApp/Db/Keithley2kDMM_mf.db","P=raspi:,Dmm=D1,PORT=serial1")
#doAfterIocInit("seq &Keithley2kDMM, 'P=raspi:, Dmm=D1, channels=22, model=2700'")

# Oxford Cyberstar X1000 Scintillation detector and pulse processing unit
#dbLoadRecords("$(IP)/ipApp/Db/Oxford_X1k.db","P=raspi:,S=s1,PORT=serial4")

# Oxford ILM202 Cryogen Level Meter (Serial)
#dbLoadRecords("$(IP)/ipApp/Db/Oxford_ILM202.db","P=raspi:,S=s1,PORT=serial5")

# Elcomat autocollimator
#dbLoadRecords("$(IP)/ipApp/Db/Elcomat.db", "P=raspi:,PORT=serial8")

# Eurotherm temp controller
#dbLoadRecords("$(IP)/ipApp/Db/Eurotherm.db","P=raspi:,PORT=serial7")

# MKS vacuum gauges
#dbLoadRecords("$(IP)/ipApp/Db/MKS.db","P=raspi:,PORT=serial2,CC1=cc1,CC2=cc3,PR1=pr1,PR2=pr3")

# PI Digitel 500/1500 pump
#dbLoadRecords("$(IP)/ipApp/Db/Digitel.db","raspi:,PUMP=ip1,PORT=serial3")

# PI MPC ion pump
#dbLoadRecords("$(IP)/ipApp/Db/MPC.db","P=raspi:,PUMP=ip2,PORT=serial4,PA=0,PN=1")

# PI MPC TSP (titanium sublimation pump)
#dbLoadRecords("$(IP)/ipApp/Db/TSP.db","P=raspi:,TSP=tsp1,PORT=serial4,PA=0")

# Heidenhain ND261 encoder (for PSL monochromator)
#dbLoadRecords("$(IP)/ipApp/Db/heidND261.db", "P=raspi:,PORT=serial1")

# Love Controllers
#devLoveDebug=1
#loveServerDebug=1
#dbLoadRecords("$(IP)/ipApp/Db/love.db", "P=raspi:,Q=Love_0,C=0,PORT=PORT2,ADDR=1")

# END serial.cmd --------------------------------------------------------------
