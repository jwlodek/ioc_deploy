# ioc_deploy #
This script create a portable deployment of an areaDetector plugin that was previously compiled locally. The script copies all of the
important files from the local installation into a given target directory, and creates an envPaths file that can  direct an IOC to use the
files in this new directory.

## Requirements ##
- ADSupport, ADCore, and any detectors to be copied must be compiled already.
- The EPICS modules that these plugins depend on must be compiled already.
  - asyn, autosave, busy, calc, seq, sscan, (dev)iocStats
- EPICS base must be compiled already
- Note: The envPaths file created uses absolute paths; thus, moving the deployment will break the IOC unless the envPaths file is modified.

## Usage ##
Before using the script, it is necessary to define the BASE, DETECTOR, and SUPPORT macros which define the path 
to EPICS base, areaDetector, and EPICS modules, respectively. The TARGET macro, which defines the location of the deployment,
may also be defined in the script or passed as a command line argument (the command line argument has priority over the value
in the script). Additionally, the name of a detector to add can be passed as a second argument. 
