# Linux startup script

# This doesn't do any good at the moment, because the MicroZed doesn't have ntp.
epicsEnvSet("EPICS_TS_NTP_INET", "164.54.100.129")

# For devIocStats
epicsEnvSet("ENGINEER","engineer")
epicsEnvSet("LOCATION","location")
epicsEnvSet("GROUP","group")

< envPaths

epicsEnvSet("PREFIX", "zzz:")
epicsEnvSet("STREAM_PROTOCOL_PATH", "$(TOP)/iocBoot/$(IOC)")

# save_restore.cmd needs the full path to the startup directory, which
# envPaths currently does not provide
epicsEnvSet(STARTUP,$(TOP)/iocBoot/$(IOC))

# Increase size of buffer for error logging from default 1256
errlogInit(20000)

# Specify largest array CA will transport
# Note for N doubles, need N*8 bytes+some overhead
#epicsEnvSet EPICS_CA_MAX_ARRAY_BYTES 4000100
epicsEnvSet EPICS_CA_MAX_ARRAY_BYTES 8000100

################################################################################
# Tell EPICS all about the record types, device-support modules, drivers,
# etc. in the software we just loaded (zzz.munch)
dbLoadDatabase("../../dbd/ioczzzLinux_arm.dbd")
ioczzzLinux_arm_registerRecordDeviceDriver(pdbbase)

### save_restore setup
< save_restore.cmd

# record to do "rmmod dmaproxy; modprobe dmaproxy" when processed
dbLoadRecords("$(TOP)/zzzApp/Db/resetDMA.db","P=$(PREFIX)")


# Access Security
dbLoadRecords("$(TOP)/zzzApp/Db/Security_Control.db","P=$(PREFIX)")
asSetFilename("$(TOP)/iocBoot/accessSecurity.acf")
asSetSubstitutions("P=$(PREFIX)")

### caputRecorder

# trap listener
dbLoadRecords("$(CAPUTRECORDER)/caputRecorderApp/Db/caputPoster.db","P=$(PREFIX),N=300")
doAfterIocInit("registerCaputRecorderTrapListener('$(PREFIX)caputRecorderCommand')")

# GUI database
dbLoadRecords("$(CAPUTRECORDER)/caputRecorderApp/Db/caputRecorder.db","P=$(PREFIX),N=300")


< softGlueZynq.iocsh

# if you have hdf5 and szip, you can use this
#< areaDetector.cmd

# quadEM support for TetrAMM
#< TetrAMM.cmd

#var devSGscaler16Debug,10
dbLoadRecords("$(SCALER)/scalerApp/Db/scaler16m.db","P=$(PREFIX),S=scaler1,OUT=#C0 S0 @, DTYP=SGscaler16, FREQ=10000000")

# user-assignable ramp/tweak
dbLoadRecords("$(STD)/stdApp/Db/ramp_tweak.db","P=$(PREFIX),Q=rt1")
dbLoadRecords("$(STD)/stdApp/Db/ramp_tweak.db","P=$(PREFIX),Q=rt2")

# serial support
#< serial.cmd


### Scan-support software
# crate-resident scan.  This executes 1D, 2D, 3D, and 4D scans, and caches
# 1D data, but it doesn't store anything to disk.  (See 'saveData' below for that.)
dbLoadRecords("$(SSCAN)/sscanApp/Db/standardScans.db","P=$(PREFIX),MAXPTS1=10000,MAXPTS2=10000,MAXPTS3=10000,MAXPTS4=10000,MAXPTSH=1000000")
dbLoadRecords("$(SSCAN)/sscanApp/Db/saveData.db","P=$(PREFIX)")
# Run this after iocInit:
doAfterIocInit("saveData_Init(saveData.req, 'P=$(PREFIX)')")
dbLoadRecords("$(SSCAN)/sscanApp/Db/scanProgress.db","P=$(PREFIX)scanProgress:")
# Run this after iocInit:
doAfterIocInit("seq &scanProgress, 'S=$(PREFIX), P=$(PREFIX)scanProgress:'")

### Stuff for user programming ###
< calc.iocsh

# Slow feedback
#dbLoadTemplate "pid_slow.substitutions"
#dbLoadTemplate "async_pid_slow.substitutions"
#dbLoadTemplate "fb_epid.substitutions"

# Miscellaneous PV's, such as burtResult
dbLoadRecords("$(STD)/stdApp/Db/misc.db","P=$(PREFIX)")

# devIocStats
dbLoadRecords("$(DEVIOCSTATS)/db/iocAdminSoft.db","IOC=zzz")

### Load database record for alive heartbeating support.
# RHOST specifies the IP address that receives the heartbeats.
dbLoadRecords("$(ALIVE)/aliveApp/Db/alive.db", "P=$(PREFIX),RHOST=164.54.100.11")

###############################################################################
iocInit
###############################################################################

# write all the PV names to a local file
dbl > dbl-all.txt

# Report  states of database CA links
dbcar(*,1)

# print the time our boot was finished
date

# The softGlueZynq DMA doesn't initialize cleanly. To work around, execute
# the following commands:
system("caput zzz:SG:BUFFER-1_IN_Signal 1!")
system("sleep 1")
system("rmmod dmaproxy")
system("modprobe dmaproxy")
