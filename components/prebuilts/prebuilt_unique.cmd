epicsEnvSet("ENGINEER",			   "Michael Rolland")
epicsEnvSet("LOCATION",		   	   "741")
epicsEnvSet("TOP",			   "${PWD}")
epicsEnvSet("PORT",			   "CAM")

epicsEnvSet("EPICS_CA_AUTO_ADDR_LIST",     "NO")
epicsEnvSet("EPICS_CA_ADDR_LIST",	   "10.10.0.255")
epicsEnvSet("EPICS_CA_MAX_ARRAY_BYTES",    "10000000")

epicsEnvSet("CAM-IP",			   "10.10.1.91")
# epicsEnvSet("UID_NUM", 		   "")
epicsEnvSet("PREFIX", 		   	   "XF:10IDC-BI{GC1380-Cam:1}")
epicsEnvSet("CTPREFIX", 		   "$PREFIX")
epicsEnvSet("HOSTNAME", 		   "xf10id-is1")
epicsEnvSet("IOCNAME", 		   	   "gc1380")

epicsEnvSet("QSIZE", 			   "20")
epicsEnvSet("NCHANS", 		   	   "2048")
epicsEnvSet("HIST_SIZE", 		   "4096")
epicsEnvSet("XSIZE", 			   "1360")
epicsEnvSet("YSIZE",			   "1024")
epicsEnvSet("NELMT", 			   "4177920")
epicsEnvSet("NDTYPE",			   "Int16")
epicsEnvSet("NDFTVL", 		   	   "SHORT")
epicsEnvSet("CBUFFS", 		   	   "500")
