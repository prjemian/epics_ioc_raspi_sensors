#epicsEnvSet EPICS_CA_MAX_ARRAY_BYTES 2000100

# Create a simDetector driver
simDetectorConfig("SIM1", 640, 480, 1, 50, 50000000)
dbLoadRecords("$(ADCORE)/ADApp/Db/ADBase.template",     "P=raspi:,R=SIM1:cam1:,PORT=SIM1,ADDR=0,TIMEOUT=1")
dbLoadRecords("$(ADCORE)/ADApp/Db/simDetector.template","P=raspi:,R=SIM1:cam1:,PORT=SIM1,ADDR=0,TIMEOUT=1")

# Create a second simDetector driver
simDetectorConfig("SIM2", 300, 200, 1, 50, 50000000)
dbLoadRecords("$(ADCORE)/ADApp/Db/ADBase.template",     "P=raspi:,R=SIM1:cam2:,PORT=SIM2,ADDR=0,TIMEOUT=1")
dbLoadRecords("$(ADCORE)/ADApp/Db/simDetector.template","P=raspi:,R=SIM1:cam2:,PORT=SIM2,ADDR=0,TIMEOUT=1")

# Create a standard arrays plugin, set it to get data from first simDetector driver.
NDStdArraysConfigure("SIM1Image", 3, 0, "SIM1", 0, 2000000)
dbLoadRecords("$(ADCORE)/ADApp/Db/NDPluginBase.template", "P=raspi:,R=image1:,PORT=SIM1Image,ADDR=0,TIMEOUT=1,NDARRAY_PORT=SIM1,NDARRAY_ADDR=0")
dbLoadRecords("$(ADCORE)/ADApp/Db/NDStdArrays.template", "P=raspi:,R=image1:,PORT=SIM1Image,ADDR=0,TIMEOUT=1,TYPE=Int8,FTVL=UCHAR,NELEMENTS=1392640")

# Create a standard arrays plugin, set it to get data from second simDetector driver.
NDStdArraysConfigure("SIM2Image", 1, 0, "SIM2", 0, 2000000)
dbLoadRecords("$(ADCORE)/ADApp/Db/NDPluginBase.template", "P=raspi:,R=image2:,PORT=SIM2Image,ADDR=0,TIMEOUT=1,NDARRAY_PORT=SIM1,NDARRAY_ADDR=0")
dbLoadRecords("$(ADCORE)/ADApp/Db/NDStdArrays.template", "P=raspi:,R=image2:,PORT=SIM2Image,ADDR=0,TIMEOUT=1,TYPE=Int8,FTVL=UCHAR,NELEMENTS=1392640")

# Create a file saving plugin
NDFileNetCDFConfigure("SIM1File", 20, 0, "SIM1", 0)
dbLoadRecords("$(ADCORE)/ADApp/Db/NDPluginBase.template", "P=raspi:,R=netCDF1:,PORT=SIM1File,ADDR=0,TIMEOUT=1,NDARRAY_PORT=SIM1,NDARRAY_ADDR=0")
dbLoadRecords("$(ADCORE)/ADApp/Db/NDFile.template",      "P=raspi:,R=netCDF1:,PORT=SIM1File,ADDR=0,TIMEOUT=1")

# Create an ROI plugin
NDROIConfigure("SIM1ROI", 20, 0, "SIM1", 0, 8, 20, 20000000)
dbLoadRecords("$(ADCORE)/ADApp/Db/NDPluginBase.template", "P=raspi:,R=ROI1:,  PORT=SIM1ROI,ADDR=0,TIMEOUT=1,NDARRAY_PORT=SIM1,NDARRAY_ADDR=0")
dbLoadRecords("$(ADCORE)/ADApp/Db/NDROI.template",  "P=raspi:,R=ROI1:,  PORT=SIM1ROI,ADDR=0,TIMEOUT=1")

# Create an HDF5 file saving plugin
NDFileHDF5Configure("FileHDF1", 20, 0, "SIM1", 0)
dbLoadRecords("$(ADCORE)/db/NDPluginBase.template","P=raspi:,R=HDF1:,PORT=FileHDF1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=SIM1,NDARRAY_ADDR=0")
dbLoadRecords("$(ADCORE)/db/NDFile.template",      "P=raspi:,R=HDF1:,PORT=FileHDF1,ADDR=0,TIMEOUT=1")
dbLoadRecords("$(ADCORE)/db/NDFileHDF5.template",  "P=raspi:,R=HDF1:,PORT=FileHDF1,ADDR=0,TIMEOUT=1")
