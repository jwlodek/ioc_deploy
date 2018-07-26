#!/bin/bash

#BASE=/epics/base-7.0.1.1
#DETECTOR=/home/mrolland/Documents/epics/synAppsRelease/synApps/support/areaDetector-master
#SUPPORT=/home/mrolland/Documents/epics/synAppsRelease/synApps/support
TARGET=
BASE=
DETECTOR=
SUPPORT=

if [ -z $BASE ] || ! [ -d $BASE ]; then
    echo Invalid EPICS base path. Exiting
    exit 1
fi

if [ -z $DETECTOR ] || ! [ -d $DETECTOR ]; then
    echo Invalid areaDetector path. Exiting
    exit 1
fi

if [ -z $SUPPORT ] || ! [ -d $SUPPORT ]; then
    echo Invalid support path. Exiting
    exit 1
fi

if ! [ -z $1 ]; then
    TARGET=$1
fi

if ! [ -z $TARGET ]; then
	mkdir -p $TARGET

	HOME="$(pwd)"
	
	cd $DETECTOR
	AD_DIR="$(echo ${PWD##*/})"
	cd $HOME
	mkdir -p $TARGET/$AD_DIR
	AD_DIR=$TARGET/$AD_DIR

	cd $BASE
	BASE_DIR="$(echo ${PWD##*/})"
	cd $HOME
	mkdir -p $TARGET/$BASE_DIR
	cp -r -n $BASE/bin $TARGET/$BASE_DIR

	echo looking for ADCore...
	# CORE="$(ls $DETECTOR | grep -m 1 ADCore)"
	# if ! [ -z $CORE ]; then
	        # echo copying $CORE...
	        # mkdir -p $TARGET/areaDetector/$CORE/ADApp
	        # cp -r -n $DETECTOR/$CORE/bin $AD_DIR/$CORE
	        # cp -r -n $DETECTOR/$CORE/lib $AD_DIR/$CORE
 	        # cp -r -n $DETECTOR/$CORE/db $AD_DIR/$CORE
	        # cp -r -n $DETECTOR/$CORE/documentation $AD_DIR/$CORE
	        # cp -r -n $DETECTOR/$CORE/iocBoot $AD_DIR/$CORE
	        # cp -r -n $DETECTOR/$CORE/Viewers $AD_DIR/$CORE
	        # cp -r -n $DETECTOR/$CORE/ADApp/Db $AD_DIR/$CORE/ADApp
	        # cp -r -n $DETECTOR/$CORE/ADApp/op $AD_DIR/$CORE/ADApp
	# else
	        # echo Not found
	# fi

	echo copying ADCore...
	mkdir -p $AD_DIR/ADCore/ADApp
	cp -r -n $DETECTOR/ADCore/bin $AD_DIR/ADCore
	cp -r -n $DETECTOR/ADCore/lib $AD_DIR/ADCore
	cp -r -n $DETECTOR/ADCore/db $AD_DIR/ADCore
	cp -r -n $DETECTOR/ADCore/documentation $AD_DIR/ADCore
	cp -r -n $DETECTOR/ADCore/iocBoot $AD_DIR/ADCore
	cp -r -n $DETECTOR/ADCore/Viewers $AD_DIR/ADCore
	cp -r -n $DETECTOR/ADCore/ADApp/Db $AD_DIR/ADCore/ADApp
	cp -r -n $DETECTOR/ADCore/ADApp/op $AD_DIR/ADCore/ADApp

	echo looking for ADSupport...
	ADSUPPORT="$(ls $DETECTOR | grep -m 1 ADSupport)"
	if ! [ -z $ADSUPPORT ]; then
	    echo copying $ADSUPPORT...
	    mkdir -p $AD_DIR/$ADSUPPORT
	    cp -r -n $DETECTOR/$ADSUPPORT/bin $AD_DIR/$ADSUPPORT
	    cp -r -n $DETECTOR/$ADSUPPORT/lib $AD_DIR/$ADSUPPORT
	    cp -r -n $DETECTOR/$ADSUPPORT/supportApp $AD_DIR/$ADSUPPORT
	    echo done.
	else
	    echo Not found.
	fi

	echo looking for asyn...
	ASYN="$(ls $SUPPORT | grep -m 1 asyn)"
	if ! [ -z $ASYN ]; then
	    echo copying $ASYN...
	    mkdir -p $TARGET/$ASYN
	    cp -r -n $SUPPORT/$ASYN/bin $TARGET/$ASYN
	    cp -r -n $SUPPORT/$ASYN/db $TARGET/$ASYN
	    cp -r -n $SUPPORT/$ASYN/opi $TARGET/$ASYN
	    cp -r -n $SUPPORT/$ASYN/lib $TARGET/$ASYN
	    echo done.
	else
	    echo Not found.
	fi

	echo looking for autosave...
	SAVE="$(ls $SUPPORT | grep -m 1 autosave)"
	if ! [ -z $SAVE ]; then
	    echo copying $SAVE...
	    mkdir -p $TARGET/$SAVE/asApp
	    cp -r -n $SUPPORT/$SAVE/asApp/Db $TARGET/$SAVE/asApp
	    cp -r -n $SUPPORT/$SAVE/asApp/op $TARGET/$SAVE/asApp
	    cp -r -n $SUPPORT/$SAVE/bin $TARGET/$SAVE
	    echo done.
	else
	    echo Not found.
	fi

	echo looking for busy...
	BUSY="$(ls $SUPPORT | grep -m 1 busy)"
	if ! [ -z $BUSY ]; then
	    echo copying $BUSY...
	    mkdir -p $TARGET/$BUSY/busyApp
	    cp -r -n $SUPPORT/$BUSY/busyApp/Db $TARGET/$BUSY/busyApp
	    cp -r -n $SUPPORT/$BUSY/busyApp/op $TARGET/$BUSY/busyApp
	    echo done.
	fi

	echo looking for calc...
	CALC="$(ls $SUPPORT | grep -m 1 calc)"
	if ! [ -z $CALC ]; then
	    echo copying $CALC...
	    mkdir -p $TARGET/$CALC/calcApp
	    cp -r -n $SUPPORT/$CALC/calcApp/Db $TARGET/$CALC/calcApp
	    cp -r -n $SUPPORT/$CALC/calcApp/op $TARGET/$CALC/calcApp
	    echo done.
	else
	    echo Not found.
	fi

	echo looking for devIocStats...
	DSTATS="$(ls $SUPPORT | grep -m 1 devIocStats)"
	if ! [ -z $DSTATS ]; then
	    echo copying $DSTATS...
	    mkdir -p $TARGET/$DSTATS
	    cp -r -n $SUPPORT/$DSTATS/bin $TARGET/$DSTATS
	    cp -r -n $SUPPORT/$DSTATS/lib $TARGET/$DSTATS
	    cp -r -n $SUPPORT/$DSTATS/db $TARGET/$DSTATS
	    cp -r -n $SUPPORT/$DSTATS/op $TARGET/$DSTATS
	    echo done.
	else
	    echo Not found.
	fi

	echo looking for iocStats...
	STATS="$(ls $SUPPORT | grep -m 1 iocStats)"
	if ! [ -z $STATS ]; then
	    echo copying $STATS...
	    mkdir -p $TARGET/$STATS
	    cp -r -n $SUPPORT/$STATS/bin $TARGET/$STATS
	    cp -r -n $SUPPORT/$STATS/lib $TARGET/$STATS
	    cp -r -n $SUPPORT/$STATS/db $TARGET/$STATS
	    cp -r -n $SUPPORT/$STATS/op $TARGET/$STATS
	    echo done.
	else
	    echo Not found.
	fi

	echo looking for sscan...
	SCAN="$(ls $SUPPORT | grep -m 1 sscan)"
	if ! [ -z $SCAN ]; then
	    echo copying $SCAN...
	    mkdir -p $TARGET/$SCAN/sscanApp
	    cp -r -n $SUPPORT/$SCAN/sscanApp/Db $TARGET/$SCAN/sscanApp
	    cp -r -n $SUPPORT/$SCAN/sscanApp/op $TARGET/$SCAN/sscanApp
	    echo done.
	else
	    echo Not found.
	fi

	echo looking for seq...
	SEQ="$(ls $SUPPORT | grep -m 1 seq)"
	if ! [ -z $SEQ ]; then
	    echo copying $SEQ...
	    mkdir -p $TARGET/$SEQ
	    cp -r -n $SUPPORT/$SEQ/lib $TARGET/$SEQ
	    cp -r -n $SUPPORT/$SEQ/bin $TARGET/$SEQ
	    echo done.
	else
	    echo Not found.
	fi

	echo creating envPaths file...
	cd $TARGET/$ASYN
	ASYN_DIR="$(pwd)"
	cd $HOME
	cd $TARGET/$BUSY
	BUSY_DIR="$(pwd)"
	cd $HOME
	cd $TARGET/$SAVE
	SAVE_DIR="$(pwd)"
	cd $HOME
	cd $TARGET/$CALC
	CALC_DIR="$(pwd)"
	cd $HOME
	cd $TARGET/$SEQ
	SEQ_DIR="$(pwd)"
	cd $HOME
	cd $TARGET/$SCAN
	SCAN_DIR="$(pwd)"
	cd $HOME
	if ! [ -z $STATS ]; then
	    cd $TARGET/$STATS
	    STATS_DIR="$(pwd)"
	    cd $HOME
	else
	    cd $TARGET/$DSTATS
	    STATS_DIR="$(pwd)"
	    cd $HOME
	fi
	cd $TARGET
	SUPPORT_DIR="$(pwd)"
	cd $HOME
	cd $AD_DIR
	AD_DIR="$(pwd)"
	cd $HOME
	cd $TARGET/$BASE_DIR
        BASE_DIR="$(pwd)"
	
	cd $HOME
	cd $TARGET
	echo \# put this file in IOC folders to use this deployment. > envPaths
	echo \# plugins added with [absolute]fullDeploy.sh will automatically have this file with appropriate paths copied in. >> envPaths
	echo >> envPaths
	echo epicsEnvSet\(\"SUPPORT\", \"$SUPPORT_DIR\"\) >> envPaths
	echo epicsEnvSet\(\"ASYN\", \"$ASYN_DIR\"\) >> envPaths
	echo epicsEnvSet\(\"AREA_DETECTOR\", \"$AD_DIR\"\) >> envPaths
	echo epicsEnvSet\(\"ADSUPPORT\", \"$AD_DIR/$ADSUPPORT\"\) >> envPaths
	echo epicsEnvSet\(\"ADCORE\", \"$AD_DIR/ADCore\"\) >> envPaths
	echo epicsEnvSet\(\"AUTOSAVE\", \"$SAVE_DIR\"\) >> envPaths
	echo epicsEnvSet\(\"BUSY\", \"$BUSY_DIR\"\) >> envPaths
	echo epicsEnvSet\(\"CALC\", \"$CALC_DIR\"\) >> envPaths
	echo epicsEnvSet\(\"SNSEQ\", \"$SEQ_DIR\"\) >> envPaths
	echo epicsEnvSet\(\"SSCAN\", \"$SCAN_DIR\"\) >> envPaths
	echo epicsEnvSet\(\"DEVIOCSTATS\", \"$STATS_DIR\"\) >> envPaths
	echo epicsEnvSet\(\"EPICS_BASE\", \"$BASE_DIR\"\) >> envPaths
	echo \# epicsEnvSet\(\"TOP\", \"\<path to plugin/iocs/pluginIOC\>\"\) >> envPaths
	echo \# epicsEnvSet\(\"IOC\", \"\<iocPlugin\>\"\) >> envPaths
	echo \# epicsEnvSet\(\"\<PLUGIN_NAME\>\", \"\<path to plugin\>\"\) >> envPaths
	cd $HOME
	echo done.

	
	echo creating README...
	cd $TARGET
	echo "This deployment of areaDetector was created by absoluteFullDeploy.sh" > README.txt
	echo "from https://github.com/rollandmichae7/ioc_deploy" >> README.txt
	echo >> README.txt
	echo "To use IOCs with this deployment, copy the envPaths file" >> README.txt
	echo "from this directory into the IOC's directory and fill in" >> README.txt 
	echo "the 3 required plugin-dependent variables in the file." >> README.txt
	echo "For plugins that use st.cmd.linux and st.cmd.windows," >> README.txt
	echo "copy envPaths as envPaths.linux or envPaths.windows" >> README.txt
	echo "according to to your architecture." >> README.txt
	echo "Any plugin added during the running of the script" >> README.txt
	echo "will already have envPaths configured." >> README.txt
	echo >> README.txt
	echo "WARNING: envPaths uses absolute paths based on the location" >> README.txt
	echo "of this deployment's initial creation. These will break if this" >> README.txt
	echo "deployment is moved, and the IOC will not work." >> README.txt
	echo "If this deployment is moved, envPaths MUST be updated." >> README.txt
	cd $HOME
	echo done.


	if ! [ -z "$2" ]; then
	    CHOICE=$2
	else
	    echo Enter name of an AD plugin to add or \"done\" to exit:
	    read CHOICE
	fi
	while ! [ $CHOICE = done ]; do
	    PLUGIN="$(ls $DETECTOR | grep -m 1 $CHOICE)"
	    if [ -z "$PLUGIN" ]; then
		echo Invalid plugin name.
	    else
		echo copying $PLUGIN...
		APP="$(ls $DETECTOR/$PLUGIN | grep App)"
		cd $DETECTOR
		AD_DIR="$(echo ${PWD##*/})"
		cd $HOME
		AD_DIR=$TARGET/$AD_DIR
		IOC="$(ls $DETECTOR/$PLUGIN/iocs | grep IOC)"
      		mkdir -p $AD_DIR/$PLUGIN/iocs/$IOC
		# cp -r -n $DETECTOR/$PLUGIN/bin $AD_DIR/$PLUGIN
		cp -r -n $DETECTOR/$PLUGIN/db $AD_DIR/$PLUGIN
		# cp -r -n $DETECTOR/$PLUGIN/documentation $AD_DIR/$PLUGIN
		cp -r -n $DETECTOR/$PLUGIN/iocs/$IOC/bin $AD_DIR/$PLUGIN/iocs/$IOC
		cp -r -n $DETECTOR/$PLUGIN/iocs/$IOC/dbd $AD_DIR/$PLUGIN/iocs/$IOC
		cp -r -n $DETECTOR/$PLUGIN/iocs/$IOC/iocBoot $AD_DIR/$PLUGIN/iocs/$IOC
		# cp -r -n $DETECTOR/$PLUGIN/iocs $AD_DIR/$PLUGIN
		# cp -r -n $DETECTOR/$PLUGIN/lib $AD_DIR/$PLUGIN
		# cp -r -n $DETECTOR/$PLUGIN/$APP/Db $AD_DIR/$PLUGIN/$APP
		# cp -r -n $DETECTOR/$PLUGIN/$APP/op $AD_DIR/$PLUGIN/$APP
		echo done.
	    fi
	    if [ "$CHOICE" = "$2" ]; then
		exit 1
	    fi
	    cd $HOME
	    echo Name of AD plugin to add:
	    read CHOICE
	done
else
    echo Invalid TARGET. Did you set one?
fi
