if [ -z "$1" ]; then
    echo No input. Path to IOC required
    exit 1
fi

if ! [ -d "$1" ]; then
    echo Invalid path: $1
    exit 1
fi

VALID=$(ls $1 | grep st.cmd)
if [ -z "$VALID" ]; then
    echo Invalid directory, no st.cmd: $1
    exit 1
fi

echo IOC path: $1

echo copying prebuilts...
cp -n prebuilts/prebuilt_unique.cmd $1 
cp -n prebuilts/prebuilt_st.cmd $1
cp -n prebuilts/prebuilt_config $1

cd $1
echo moving EPICS variable declarations to prebuilt_unique.cmd...
echo >> prebuilt_unique.cmd
echo \# additional EPICS variables extracted from st.cmd >> prebuilt_unique.cmd
UNIQUE="$(grep '< unique.cmd' st.cmd)"
if [ -z "$UNIQUE" ]; then
    env=$(grep '< envPaths' st.cmd)
    if ! [ -z "$env" ]; then
	sed -i '/< envPaths/a < prebuilt_unique.cmd' st.cmd
    else
	sed -i "1i< prebuilt_unique.cmd" st.cmd
    fi
fi
hasEnv="$(grep 'epicsEnvSet(' st.cmd)"
if ! [ -z "$hasEnv" ]; then
    grep 'epicsEnvSet(' st.cmd | while read line; do
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
grep -v 'epicsEnvSet(' st.cmd > prebuilt_temp
mv prebuilt_temp st.cmd
sed -i '1i# all epicsEnvSet calls moved to prebuilt_unique.cmd' st.cmd
echo done.
