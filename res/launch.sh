#!/bin/bash

pkill -f hwt
# https://stackoverflow.com/a/5265862/488635
prog_dir=$(cd "$(dirname "$1")" && pwd -P)/$(basename "$1")
export LD_LIBRARY_PATH=$prog_dir:$LD_LIBRARY_PATH
cd "$prog_dir" && ./tsp-rubik-rs