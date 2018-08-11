#!/bin/bash

if [ "$1" = -h ]; then
    echo "Standardize an IOC and change its envPaths to use this deployment."
    echo "Arguments: "
    echo "Path to IOC folder"
    echo "Driver name"
    echo
    echo "bash standardizeIOC.sh /epics/iocs/cam-GC1380 ADProsilica"
    exit 1
fi
if [ -z "$1" ] || [ -z "$2" ]; then
    echo Invalid input.
    echo Required input: Path to IOC and driver name
    echo
    echo bash standardizeIOC.sh /epics/iocs/cam-GC1380 ADProsilica
    exit 1
fi

if ! [ -d "$1" ]; then
    echo Invalid path: $1
    exit 1
fi

echo IOC path: $1
echo Driver: $2
echo

echo copying prebuilts...
cp -n prebuilts/prebuilt_unique.cmd $1
cp -n prebuilts/prebuilt_config $1
echo

HOME=$(pwd)

echo copying EPICS variable declarations to prebuilt_unique.cmd...
cd $1
VALID=$(ls | grep -E '(^|\s)st.cmd($|\s)')
if ! [ -z "$VALID" ]; then
    mv st.cmd OLD_st.cmd
    echo >> prebuilt_unique.cmd
    echo \# additional EPICS variables extracted from st.cmd >> prebuilt_unique.cmd
    hasEnv="$(grep 'epicsEnvSet(' OLD_st.cmd)"
    if ! [ -z "$hasEnv" ]; then
	grep 'epicsEnvSet(' OLD_st.cmd | while read line; do
	    var=$(echo $line | cut -d \" -f 2)
	    value=$(echo $line | cut -d \" -f 4)
	    echo var: $var value: $value
	    varLineNum=$(grep -n -m 1 $var prebuilt_unique.cmd | grep -Eo '^[^:]+')
	    isComment=$(echo $line | grep \#)
	    if ! [ -z "$varLineNum" ] && [ -z "$isComment" ]; then
		oldLine=$(sed "${varLineNum}q;d" prebuilt_unique.cmd)
		sed -i "${varLineNum}s/$oldLine/$line/" prebuilt_unique.cmd
	    else
		echo $line >> prebuilt_unique.cmd
	    fi
	done
    fi
else
    echo st.cmd not found.
fi

# remove envSet calls from st.cmd
# grep -v 'epicsEnvSet(' st.cmd > prebuilt_temp
# mv prebuilt_temp st.cmd
# sed -i '1i# all epicsEnvSet calls copied to prebuilt_unique.cmd' st.cmd
echo

cd $HOME

echo generating envPaths...
bash scripts/generateEnvPaths.sh $1 $2
echo

echo copying prebuilt st.cmd...
driver=$(ls prebuilts | grep -m 1 "$2")
if ! [ -z "$driver" ]; then
    echo Found prebuilt: $driver
    cp prebuilts/$driver $1
    # python3 scripts/moveCalls.py $1/OLD_st.cmd $1/$driver
    cd areaDetector*/$2/iocs/*IOC/bin
    APPDIR=$(pwd)
    APP=$(ls */* | grep -m 1 App)
    if ! [ -z "$APPDIR" ] && ! [ -z "$APP" ]; then
	echo App path: $APPDIR/$APP
	cd $HOME
	cd $1
	var="#!$APPDIR/$APP st.cmd"
	sed -i "1s@.*@$var@" $driver
    else
	echo Could not find IOC binary.
    fi
    cd $HOME
    mv $1/$driver $1/st.cmd
else
    echo Could not find prebuilt st.cmd for $2
    OLD=$(ls $1 | grep 'OLD_st.cmd')
    if ! [ -z "$OLD" ]; then
	mv $1/OLD_st.cmd $1/st.cmd
    fi
fi
echo

echo done.
