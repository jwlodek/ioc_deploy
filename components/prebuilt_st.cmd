#!/epics/support/AD3-1/ADProsilica/iocs/prosilicaIOC/bin/linux-x86_64/prosilicaApp

errlogInit(20000)

< envPaths
< prebuilt_unique.cmd

# dbLoadDatabase("$(TOP)/dbd/prosilicaApp.dbd")
# App_registerRecordDeviceDriver(pdbbase)

asynSetTraceIOMask("$(PORT)",0,2)

dbLoadRecords("$(ADCORE)/db/ADBase.template",   "P=$(PREFIX),R=cam1:,PORT=$(PORT),ADDR=0,TIMEOUT=1")
dbLoadRecords("$(ADCORE)/db/NDFile.template",   "P=$(PREFIX),R=cam1:,PORT=$(PORT),ADDR=0,TIMEOUT=1")

# Create a standard arrays plugin, set it to get data from first Prosilica driver.
NDStdArraysConfigure("Image1", 5, 0, "$(PORT)", 0, 0)
dbLoadRecords("$(ADCORE)/db/NDPluginBase.template","P=$(PREFIX),R=image1:,PORT=Image1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT),NDARRAY_ADDR=0")

dbLoadRecords("$(ADCORE)/db/NDStdArrays.template", "P=$(PREFIX),R=image1:,PORT=Image1,ADDR=0,TIMEOUT=1,TYPE=$(NDTYPE),FTVL=$(NDFTVL),NELEMENTS=$(NELMT),NDARRAY_PORT=$(PORT),NDARRAY_ADDR=0")

# Load all other plugins using commonPlugins.cmd
< $(ADCORE)/iocBoot/commonPlugins.cmd

#remotely reboot the camera IOC if 'Ring buffer full...'
dbLoadRecords ("$(IOCSTATS)/db/iocAdminSoft.db", "IOC=$(CTPREFIX)")
dbLoadRecords ("$(AUTOSAVE)/db/save_restoreStatus.db", "P=$(PREFIX)")
save_restoreSet_status_prefix("$(PREFIX)")

## autosave/restore machinery
save_restoreSet_Debug(0)
save_restoreSet_IncompleteSetsOk(1)
save_restoreSet_DatedBackupFiles(1)

set_savefile_path("$(TOP)/as/save")
set_requestfile_path("$(TOP)")
set_requestfile_path("$(TOP)/as/req")
set_requestfile_path("$(ADCORE)/ADApp/Db")
set_requestfile_path("$(ADCORE)/iocBoot")
set_requestfile_path("$(CALC)/calcApp/Db")
set_requestfile_path("$(SSCAN)/sscanApp/Db")

system("install -m 777 -d $(TOP)/as/save")
system("install -m 777 -d $(TOP)/as/req")

set_pass0_restoreFile("auto_settings.sav")
set_pass1_restoreFile("auto_settings.sav")

#access security
#asSetFilename("/cf-update/acf/default.acf")

iocInit()

#must be after iocInit()
create_monitor_set("auto_settings.req", 30,"P=$(PREFIX)")

# Channel Finder
dbl > ./records.dbl
system "cp ./records.dbl /cf-update/$(HOSTNAME).$(IOCNAME).dbl"

# dbpf "$(PREFIX)cam1:GevSCPSPacketSiz", "8228"
