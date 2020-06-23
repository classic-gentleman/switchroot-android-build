#!/bin/bash

if [ "$(ls -A ./android/lineage)" ]; then
    echo "Sources found. Skipping..."
else
    echo "Getting sources..."
    ./get-sources.sh
fi

if [[ -f /root/android/lineage/.repo/repo/repo ]]; then
    cp /root/android/lineage/.repo/repo/repo /root/bin/repo
fi

if [[ -z $FLAGS || ! -z ${FLAGS##*noupdate*} || -z ${FLAGS##*timetravelto*} ]]; then
    TARGETDATE=$(sed -E 's/.*timetravelto\=((\w|-|\s|\:){1,}).*/\1/g' <<<$FLAGS)
    
    if [[ ! -z ${TARGETDATE} ]]; then
        echo "Target date: ${TARGETDATE}"
    fi

    ./reset-changes-update-sources.sh ${TARGETDATE}
    ./repopic-and-patch.sh
fi

if [[ -n $FLAGS && -z ${FLAGS##*forceclean*} ]]; then
    cd /root/android/lineage
    make clobber && make clean
    cd /root
fi

if [[ -z $FLAGS || ! -z ${FLAGS##*nobuild*} ]]; then
    ./build.sh
fi

if [[ "$ROM_TYPE" == "zip" ]]; then
    if [[ -z $FLAGS || ! -z ${FLAGS##*nooutput*} ]]; then
        echo "Copying output to ./android/output..."
        cd /root
        ./copy-to-output.sh
    fi
fi
