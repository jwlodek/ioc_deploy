#!/bin/bash
if [ $# -ne 2 ]; then
    echo Two parameters required: Destination and driver name \(eg. ADProsilica\)
    exit 1
fi

echo Destination: $1
echo Driver: $2

HOME=$(pwd)

cd base*
BASE=$(pwd)
cd ../asyn*
ASYN=$(pwd)
cd ../busy*
BUSY=$(pwd)
cd ../autosave*
AUTOSAVE=$(pwd)
cd ../*iocStats*
DEVIOCSTATS=$(pwd)
cd ../calc*
CALC=$(pwd)
cd ../sscan*
SSCAN=$(pwd)
cd ../seq*
SEQ=$(pwd)
cd ../areaDetector*
AREA_DETECTOR=$(pwd)
cd $2
PLUGIN=$(pwd)
cd iocs/*IOC
TOP=$(pwd)
cd $HOME

PLUGIN_NAME=$(echo $2 | tr a-z A-Z)
echo epicsEnvSet\(\"$PLUGIN_NAME\", \"$PLUGIN\"\) > envPaths
echo epicsEnvSet\(\"IOC\", \"ioc$2\"\) >> envPaths
echo epicsEnvSet\(\"TOP\", \"$TOP\"\) >> envPaths
echo epicsEnvSet\(\"SUPPORT\", \"$HOME\"\) >> envPaths
echo epicsEnvSet\(\"ASYN\", \"$ASYN\"\) >> envPaths
echo epicsEnvSet\(\"AREA_DETECTOR\", \"$AREA_DETECTOR\"\) >> envPaths
echo epicsEnvSet\(\"ADSUPPORT\", \"$AREA_DETECTOR/ADSupport\"\) >> envPaths
echo epicsEnvSet\(\"ADCORE\", \"$AREA_DETECTOR/ADCore\"\) >> envPaths
echo epicsEnvSet\(\"AUTOSAVE\", \"$AUTOSAVE\"\) >> envPaths
echo epicsEnvSet\(\"BUSY\", \"$BUSY\"\) >> envPaths
echo epicsEnvSet\(\"CALC\", \"$CALC\"\) >> envPaths
echo epicsEnvSet\(\"SNCSEQ\", \"$SEQ\"\) >> envPaths
echo epicsEnvSet\(\"SSCAN\", \"$SSCAN\"\) >> envPaths
echo epicsEnvSet\(\"DEVIOCSTATS\", \"$DEVIOCSTATS\"\) >> envPaths
echo epicsEnvSet\(\"EPICS_BASE\", \"$BASE\"\) >> envPaths
echo epicsEnvSet\(\"ADPLUGINBAR\", \"$AREA_DETECTOR/ADPluginBar\"\) >> envPaths
#echo epicsEnvSet\(\"PVA\", \"$BASE/modules\"\) >> envPaths
#echo epicsEnvSet\(\"PVACCESS\", \"$BASE/modules/pvAccess\"\) >> envPaths
#echo epicsEnvSet\(\"PVDATA\", \"$BASE/modules/pvData\"\) >> envPaths
#echo epicsEnvSet\(\"PVDATABASE\", \"$BASE/modules/pvDatabase\"\) >> envPaths
#echo epicsEnvSet\(\"NORMATIVETYPES\", \"$BASE/modules/normativeTypes\"\) >> envPaths



mv envPaths $1
