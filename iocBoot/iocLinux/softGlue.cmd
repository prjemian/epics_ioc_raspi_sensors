# BEGIN softGlue.cmd ----------------------------------------------------------
# This must run after industryPack.cmd

#devAsynSoftGlueDebug=1
#drvIP_EP201Debug=1

################################################################################
#    Initialize the FPGA
#-----------------------
#    Write content to the FPGA.    This command will fail if the FPGA already
#    has content loaded, as it will after a soft reboot.  To load new FPGA
#    content, you must power cycle the ioc.
#
#    initIP_EP200_FPGA(ushort carrier, ushort slot, char *filename)
#    carrier:  IP-carrier number (numbering begins at 0)
#    slot:     IP-slot number (numbering begins at 0)
#    filename: Name of the FPGA-content hex file to load into the FPGA.
#

#    standard softGlue 2.2
#initIP_EP200_FPGA(0, 2, "$(SOFTGLUE)/softGlueApp/Db/SoftGlue_2_2.hex")
#    standard softGlue 2.2 plus two shift registers
#initIP_EP200_FPGA(0, 2, "$(SOFTGLUE)/softGlueApp/Db/SoftGlue_2_2_Octupole_0_0.hex")
#    standard softGlue 2.2 plus two up/down counters
#initIP_EP200_FPGA(0, 2, "$(SOFTGLUE)/softGlueApp/Db/SoftGlue_2_2_1ID_Vgate_0_1.hex")
#    standard softGlue 2.2 plus two up/down counters plus two quadrature decoders
initIP_EP200_FPGA(0, 2, "$(SOFTGLUE)/softGlueApp/Db/SoftGlue_2_2_Encoder.hex")

################################################################################
#    Initialize basic field I/O 
#------------------------------
#    int initIP_EP200(ushort carrier, ushort slot, char *portName1,
#        char *portName2, char *portName3, int sopcBase)
#    carrier:   IP-carrier number (numbering begins at 0)
#    slot:      IP-slot number (numbering begins at 0)
#    portName1: Name of asyn port for component at sopcBase
#    portName2: Name of asyn port for component at sopcBase+0x10
#    portName3: Name of asyn port for component at sopcBase+0x20
#    sopcBase:  must agree with FPGA content (0x800000)
initIP_EP200(0, 2, "SGIO_1", "SGIO_2", "SGIO_3", 0x800000)

################################################################################
#    Initialize field-I/O interrupt support
#------------------------------------------
#    int initIP_EP200_Int(ushort carrier, ushort slot, int intVectorBase,
#        int risingMaskMS, int risingMaskLS, int fallingMaskMS,
#        int fallingMaskLS)
#    carrier:       IP-carrier number (numbering begins at 0)
#    slot:          IP-slot number (numbering begins at 0)
#    intVectorBase: must agree with the FPGA content loaded (0x90 for softGlue
#                   2.1 and higher; 0x80 for softGlue 2.0 and lower).  softGlue
#                   uses three vectors, for example, 0x90, 0x91, 0x92.
#    risingMaskMS:  interrupt on 0->1 for I/O pins 33-48
#    risingMaskLS:  interrupt on 0->1 for I/O pins 1-32
#    fallingMaskMS: interrupt on 1->0 for I/O pins 33-48
#    fallingMaskLS: interrupt on 1->0 for I/O pins 1-32
initIP_EP200_Int(0, 2, 0x90, 0x0, 0x0, 0x0, 0x0)

################################################################################
#    Set field-I/O data direction
#--------------------------------
#    int initIP_EP200_IO(ushort carrier, ushort slot, ushort moduleType,
#        ushort dataDir)
#    carrier:    IP-carrier number (numbering begins at 0)
#    slot:       IP-slot number (numbering begins at 0)
#    moduleType: one of [201, 202, 203, 204]
#    dataDir:    Bit mask, in which only the first 9 bits are significant.  The
#                meaning of each bit depends on moduleType, as shown in the
#                table below.  If a bit is set, the corresponding field I/O pins
#                are outputs.  Note that for the 202 and 204 modules, all I/O
#                is differential, and I/O pin N is paired with pin N+1.  For the
#                203 module, pins 25/26 through 47/48 are differential pairs.
#
#    -------------------------------------------------------------------
#    |  Correspondence between dataDir bits (0-8) and I/O pins (1-48)  |
#    -------------------------------------------------------------------
#    |             |  201          |  202/204           |  203         | 
#    -------------------------------------------------------------------
#    | bit 0       |  pins 1-8     |  pins 1, 3,25,27   |  pins 25,27  | 
#    | bit 1       |  pins 9-16    |  pins 5, 7,29,31   |  pins 29,31  | 
#    | bit 2       |  pins 17-24   |  pins 9,11,33,35   |  pins 33,35  | 
#    | bit 3       |  pins 25-32   |  pins 13,15,37,39  |  pins 37,39  | 
#    |             |               |                    |              |
#    | bit 4       |  pins 33-40   |  pins 17,19,41,43  |  pins 41,43  | 
#    | bit 5       |  pins 41-48   |  pins 21,23,45,47  |  pins 45,47  | 
#    | bit 6       |         x     |            x       |  pins 1-8    | 
#    | bit 7       |         x     |            x       |  pins 9-16   | 
#    |             |               |                    |              |
#    | bit 8       |         x     |            x       |  pins 17-24  | 
#    -------------------------------------------------------------------
#    Examples:
#    1. For the IP-EP201, moduleType is 201, and dataDir == 0x3c would mean
#       that I/O bits 17-48 are outputs.
#    2. For the IP-EP202 (IP-EP204), moduleType is 202(204), and dataDir == 0x13
#       would mean that I/O bits 1,3,25,27, 5,7,29,31, 17,19,41,43 are outputs.
#    3. For the IP-EP203, moduleType is 203, and dataDir == 0x??? would mean
#       that I/O bits 1-8, 25,27, 29,31, 33,35, 45,47 are outputs.
#initIP_EP200_IO(0, 2, 201, 0x3c)
initIP_EP200_IO(0, 2, 201, 0xc)
#initIP_EP200_IO(0, 2, 202, 0x13)

#-------------------------------------------------------------------------------
#    For backward compatibility with softGlue 2.1 and earlier, the following
#    command can be used to initialize an IP_EP201 module, instead of the
#    above calls to initIP_EP200(), initIP_EP200_Int(), and initIP_EP200_IO().
#    This won't work for any other IP_EP200 module
#
#    int initIP_EP201(char *portName, ushort carrier, ushort slot,
#        int msecPoll, int dataDir, int sopcOffset, int interruptVector,
#        int risingMask, int fallingMask)
#    portName: Name of asyn port for component at sopcOffset
#    carrier:         IP-carrier number (numbering begins at 0)
#    slot:            IP-slot number (numbering begins at 0)
#    msecPoll:        Time interval between driver polls of field I/O bits
#    dataDir:         Data direction for I/O bits, explained below.
#    sopcOffset:      SOPC offset (must be as in example below).
#    interruptVector: Must agree with the FPGA content loaded (0x90, 0x91,
#                     0x92 for softGlue 2.1 and higher; 0x80, 0x81, 0x82 for
#                     softGlue 2.0 and lower).
#    risingMask:      16-bit mask: if a bit is 1, the corresponding I/O bit will
#                     generate an interrupt when its value goes from 0 to 1.
#                     Bit 0 corresponds to field I/O pin 1, bit 1 to pin 2, etc.
#    fallingMask:     Similar to risingMask, but for 1-to-0 transitions.
#
#                     Note that the user can overwrite risingMask and
#                     fallingMask at run time, with menu selections, and
#                     probably has those selections autosaved.
#    dataDir is a bit mask in which only bits 0 and 8 are significant.
#         for sopcOffset 0x800000
#             If bit 0 of dataDir is set, I/O bits 1-8 are outputs.
#             If bit 8 of dataDir is set, I/O bits 9-16 are outputs.
#         for sopcOffset 0x800010
#             If bit 0 of dataDir is set, I/O bits 17-24 are outputs.
#             If bit 8 of dataDir is set, I/O bits 25-32 are outputs.
#         for sopcOffset 0x800020
#             If bit 0 of dataDir is set, I/O bits 33-40 are outputs.
#             If bit 8 of dataDir is set, I/O bits 41-48 are outputs.
#!initIP_EP201("SGIO_1",0,2,1000000,0x101,0x800000,0x90,0x00,0x00)
#!initIP_EP201("SGIO_2",0,2,1000000,0x101,0x800010,0x91,0x00,0x00)
#!initIP_EP201("SGIO_3",0,2,1000000,0x101,0x800020,0x92,0x00,0x00)

################################################################################
#    Initialize softGlue signal-name support
#-------------------------------------------
#    All instances of a single-register component are initialized with a single
#    call, as follows:
#
#initIP_EP201SingleRegisterPort(char *portName, ushort carrier, ushort slot)
#
# For example:
# initIP_EP201SingleRegisterPort("SOFTGLUE", 0, 2)
initIP_EP201SingleRegisterPort("SOFTGLUE", 0, 2)


################################################################################
#    Load databases
#------------------
#    Load a single database that all database fragments supporting
#    single-register components can use to show which signals are connected
#    together.  This database is not needed for the functioning of the
#    components, it's purely for the user interface.
dbLoadRecords("$(SOFTGLUE)/db/softGlue_SignalShow.db","P=raspi:,H=softGlue:,PORT=SOFTGLUE,READEVENT=10")

#    Load a set of database fragments for each single-register component.
# This database contains the records for standard softGlue, and must be loaded
# for all .hex files above 
dbLoadRecords("$(SOFTGLUE)/db/softGlue_FPGAContent.db", "P=raspi:,H=softGlue:,PORT=SOFTGLUE,READEVENT=10")

# This database contains the additional records needed for
# SoftGlue_2_2_Octupole_0_0.hex
#!dbLoadRecords("$(SOFTGLUE)/db/softGlue_FPGAContent_octupole.db", "P=raspi:,H=softGlue:,PORT=SOFTGLUE,READEVENT=10")

# This database contains the additional records needed for
# SoftGlue_2_2_1ID_Vgate_0_1.hex
#dbLoadRecords("$(SOFTGLUE)/db/softGlue_FPGAContent_s1ID_Vgate.db", "P=raspi:,H=softGlue:,PORT=SOFTGLUE,READEVENT=10")

# This database contains the additional records needed for
# SoftGlue_2_2_Encoder.hex
dbLoadRecords("$(SOFTGLUE)/db/softGlue_FPGAContent_Encoder.db", "P=raspi:,H=softGlue:,PORT=SOFTGLUE,READEVENT=10")

#    Interrupt support.
#    ('putenv' is used to fit the command into the vxWorks command line space.)
putenv "SFDB=$(SOFTGLUE)/db/softGlue_FPGAInt.db"
dbLoadRecords("$(SFDB)","P=raspi:,H=softGlue:,PORT1=SGIO_1,PORT2=SGIO_2,PORT3=SGIO_3,FIFO=10")

taskDelay(50)

#    Some stuff just for convenience: software clock and pulse generators, and
#    a couple of busy records.
dbLoadRecords("$(SOFTGLUE)/db/softGlue_convenience.db", "P=raspi:,H=softGlue:")

# configMenu Menu of softGlue circuits
dbLoadRecords("$(AUTOSAVE)/asApp/Db/configMenu.db","P=raspi:,CONFIG=SG")
# Note that the request file MUST be named $(CONFIG)Menu.req.  If the macro
# CONFIGMENU is defined with any value, backup (".savB") and sequence files
# (".savN") will not be written.  We don't want these for configMenu.
doAfterIocInit("create_manual_set('SGMenu.req','P=raspi:,CONFIG=SG,H=softGlue:,CONFIGMENU=1')")

# Register included example of a custom softGlue interrupt-service routine.
# This is for interrupts that occur too closely spaced in time for softGlue's
# normal interrupt service (an output link to an EPICS record) to handle.
#sampleCustomInterruptPrepare(0, 2, 0x800010, 0x1)

# END softGlue.cmd ------------------------------------------------------------
