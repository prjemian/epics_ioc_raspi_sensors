
# BEGIN canberra_1.cmd --------------------------------------------------------

# Commands to load a single Canberra detector with ICB electronics
#mcaRecordDebug=1
#aimDebug=1
#icbDebug=1

# AIMConfig(portName, ethernet_address, portNumber, maxChans,
#           maxSignals, maxSequences, ethernetDevice)
#    portName,         # asyn port name to be created
#    ethernet_address, # Low order 16 bits of Ethernet hardware address
#    portNumber,       # ADC port on AIM (1 or 2)
#    maxChans,         # Maximum channels for this input
#    maxSignals,       # Maximum signals for this input (>1 for MCS or multiplexor)
#    maxSequences,     # Maximum sequences for time resolved applications
#    ethernetDevice)   # Ethernet device name on IOC
#                      # Typically ei0 for Motorola 68K, dc0 for ppc, eth0 for Linux
AIMConfig("AIM1/1", 0x59e, 1, 2048, 1, 1, "eth0")
AIMConfig("AIM1/2", 0x59e, 2, 2048, 8, 1, "eth0")
AIMConfig("DSA2000", 0x8058, 1, 2048, 1, 1, "eth0")
dbLoadRecords("$(MCA)/mcaApp/Db/mca.db", "P=raspi:,M=aim_adc1,DTYP=asynMCA,INP=@asyn(AIM1/1 0),NCHAN=2048")
dbLoadRecords("$(MCA)/mcaApp/Db/mca.db", "P=raspi:,M=aim_adc2,DTYP=asynMCA,INP=@asyn(AIM1/2 0),NCHAN=2048")
dbLoadRecords("$(MCA)/mcaApp/Db/mca.db", "P=raspi:,M=aim_adc3,DTYP=asynMCA,INP=@asyn(AIM1/2 2),NCHAN=2048")
dbLoadRecords("$(MCA)/mcaApp/Db/mca.db", "P=raspi:,M=aim_adc4,DTYP=asynMCA,INP=@asyn(AIM1/2 4),NCHAN=2048")
dbLoadRecords("$(MCA)/mcaApp/Db/mca.db", "P=raspi:,M=aim_adc5,DTYP=asynMCA,INP=@asyn(AIM1/2 6),NCHAN=2048")
dbLoadRecords("$(MCA)/mcaApp/Db/mca.db", "P=raspi:,M=aim_adc6,DTYP=asynMCA,INP=@asyn(DSA2000 0),NCHAN=2048")

# icbConfig(portName, ethernetAddress, icbAddress, moduleType)
#    portName to give to this asyn port
#    ethernetAddress - Ethernet address of module, low order 16 bits
#    icbAddress - rotary switch setting inside ICB module
#    moduleType
#       0 = ADC
#       1 = Amplifier
#       2 = HVPS
#       3 = TCA
#       4 = DSP
icbConfig("icbAdc1", 0x59e, 5, 0)
dbLoadRecords("$(MCA)/mcaApp/Db/icb_adc.db", "P=raspi:,ADC=adc1,PORT=icbAdc1")
icbConfig("icbAmp1", 0x59e, 3, 1)
dbLoadRecords("$(MCA)/mcaApp/Db/icb_amp.db", "P=raspi:,AMP=amp1,PORT=icbAmp1")
icbConfig("icbHvps1", 0x59e, 2, 2)
dbLoadRecords("$(MCA)/mcaApp/Db/icb_hvps.db", "P=raspi:,HVPS=hvps1,PORT=icbHvps1,LIMIT=1000")
icbConfig("icbTca1", 0x59e, 8, 3)
dbLoadRecords("$(MCA)/mcaApp/Db/icb_tca.db", "P=raspi:,TCA=tca1,MCA=aim_adc2,PORT=icbTca1")
#icbConfig("icbDsp1", 0x8058, 0, 4)
#dbLoadRecords("$(MCA)/mcaApp/Db/icbDsp.db", "P=raspi:,DSP=dsp1,PORT=icbDsp1")

# END canberra_1.cmd ----------------------------------------------------------
