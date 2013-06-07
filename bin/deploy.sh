#!/bin/bash


SOURCE_PATH="$HOME/lekan/weinianhua/cts"
USER_SCP='root'
TARGET_PATH='/lekan/apps/'
HOST_PREFIX='192.168.0.'

for i in 60 61 62 63 64 65 66 67 68 70 71; do
    DST_HOST="${HOST_PREFIX}${i}"
    echo "start copying file to $DST_HOST ..."
    scp -r $SOURCE_PATH ${USER_SCP}@${DST_HOST}:${TARGET_PATH} 2>&1 1>/dev/null
    if [ $? -eq 0 ]; then
        echo "copy file to $DST_HOST success ..."
    else
        echo "copy file to ${DST_HOST} failed ..."
    fi
done

