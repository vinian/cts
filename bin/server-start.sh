#!/bin/bash

cd /lekan/apps/cts/src

perl /lekan/apps/cts/src/main.pl
perl /lekan/apps/cts/src/job-split.pl
perl /lekan/apps/cts/src/find-video.pl
