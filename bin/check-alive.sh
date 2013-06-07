#!/bin/bash

proc=`ps aux 2>/dev/null |grep 'get_upload_task.pl' |grep -v grep |wc -l`

if [[ $proc -eq '0' ]]; then
    echo "proc not exists."
    cd /lekan/cts/src
    perl get_upload_task.pl
else
    echo "proc alive."
fi

