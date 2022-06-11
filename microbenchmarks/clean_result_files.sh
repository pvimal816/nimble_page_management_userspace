#!/bin/bash

dir_list=("thp_verify" "stats_*")

for dir in ${dir_list[@]}; do
    echo "deleting dir $dir";
    rm -f ./*/$dir/*;
done

# rm -f ./*/thp_*/*;