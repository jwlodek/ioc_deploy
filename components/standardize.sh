COMPONENTS=/home/mrolland/MRolland/ioc_deploy/components

cp -n $COMPONENTS/prebuilt_unique.cmd .
cp -n $COMPONENTS/prebuilt_st.cmd .
cp -n $COMPONENTS/prebuilt_config ./config

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
grep -v 'epicsEnvSet(' st.cmd > temp
mv temp st.cmd
sed -i '1i# all epicsEnvSet calls moved to prebuilt_unique.cmd' st.cmd
echo done.
