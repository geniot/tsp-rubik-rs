#!/bin/bash

pkill -f hwt
export LD_LIBRARY_PATH=/mnt/SDCARD/Apps/RubikRS/tsp-rubik-rs:$LD_LIBRARY_PATH

if [ "$#" -gt 0 ]; then
 /mnt/SDCARD/Apps/RubikRS/tsp-rubik-rs "$@"
else
  progdir=$(dirname "$0")
  cd $progdir
  ./tsp-rubik-rs
fi