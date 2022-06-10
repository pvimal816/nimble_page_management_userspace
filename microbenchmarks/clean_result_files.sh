#!/bin/bash

dir_list=("stats_*" "thp_*")

for dir in ${dir_list[@]}; do
    rm -f */$dir/*;
done