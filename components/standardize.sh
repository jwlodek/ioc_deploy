#!/bin/bash

if [ "$1" = -h ]; then
    echo "Standardize an IOC and change its envPaths to use this deployment."
    echo "Arguments: "
    echo "Path to IOC folder"
    echo "Driver name"
    echo
    echo "bash standardize.sh /epics/iocs/cam-GC1380 ADProsilica"
    exit 1
fi
if [ -z "$1" ] || [ -z "$2" ]; then
    echo Invalid input.
    echo Required input: Path to IOC and driver name
    echo bash standardize.sh /epics/iocs/cam-GC1380 ADProsilica
    exit 1
fi

if ! [ -d "$1" ]; then
    echo Invalid path: $1
    exit 1
fi

echo IOC path: $1
echo Driver: $2

echo copying prebuilts...
cp -n prebuilts/* $1

HOME=$(pwd)

cd $1
mv st.cmd OLD_st.cmd
echo copying EPICS variable declarations to prebuilt_unique.cmd...
echo >> prebuilt_unique.cmd
echo \# additional EPICS variables extracted from st.cmd >> prebuilt_unique.cmd
hasEnv="$(grep 'epicsEnvSet(' OLD_st.cmd)"
if ! [ -z "$hasEnv" ]; then
    grep 'epicsEnvSet(' OLD_st.cmd | while read line; do
	var=$(echo $line | cut -d \" -f 2)
	echo var: $var
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
# remove envSet calls from st.cmd
# grep -v 'epicsEnvSet(' st.cmd > prebuilt_temp
# mv prebuilt_temp st.cmd
# sed -i '1i# all epicsEnvSet calls copied to prebuilt_unique.cmd' st.cmd

cd $HOME

echo generating envPaths...
bash scripts/generateEnvPaths.sh $1 $2

echo standardizing st.cmd...
driver=$(ls prebuilts | grep -m 1 "$2")
if ! [ -z "$driver" ]; then
    echo Found prebuilt: $driver
    cp prebuilts/$driver $1
    python scripts/moveCalls.py $1/OLD_st.cmd $1/$driver
    mv $1/$driver $1/st.cmd
else
    echo Could not find prebuilt st.cmd for $2
fi

echo done.
