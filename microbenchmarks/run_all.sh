#!/bin/bash

sudo bash /home/vimal/activate_all_devdax_numa_nodes.sh

# turnoff autonuma
sudo sysctl kernel.numa_balancing=0
# enable printing debugging info
# echo 8 > /proc/sys/kernel/printk

# echo 'file mm/exchange_page.c +p' > /sys/kernel/debug/dynamic_debug/control
# echo 'file mm/exchange.c +p' > /sys/kernel/debug/dynamic_debug/control
# echo 'file mm/migrate.c +p' > /sys/kernel/debug/dynamic_debug/control

SOURCE_NODES=(2 2 7 7)
SOURCE_CPU_NODES=(2 2 2 2)
DESTINATION_NODES=(3 9 3 9)
CONFIGURATION_NAMES=("dram to dram" "dram to pmem" "pmem to dram" "pmem to pmem")

ACTIVE_CONFIGS=(1)

for i in ${ACTIVE_CONFIGS[@]}; do
    echo "========================= >>> Executing Configuration: ${CONFIGURATION_NAMES[$i]} <<< ======================"
    export SOURCE_NODE=${SOURCE_NODES[$i]}
    export SOURCE_CPU_NODE=${SOURCE_CPU_NODES[$i]}
    export DESTINATION_NODE=${DESTINATION_NODES[$i]}

    # run concurrent page migration benchmarks
    cd concurrent_page_migration;
    make non_thp_move_pages;
    make thp_move_pages;
    echo "============executing concurrent_page_migration/run_non_thp_test.sh================"
    ./run_non_thp_test.sh
    echo "============executing concurrent_page_migration/run_thp_test.sh===================="
    ./run_thp_test.sh
    cd ..

    # run exchange page migration benchmark
    cd exchange_page_migration
    make non_thp_move_pages;
    make thp_move_pages;
    echo "============executing exchange_page_migration/run_non_thp_test.sh================"
    ./run_non_thp_test.sh
    echo "============executing exchange_page_migration/run_thp_test.sh===================="
    ./run_thp_test.sh
    cd ..

    # run parallel and native thp page migration benchmark
    cd thp_page_migration_and_parallel
    make non_thp_move_pages;
    make thp_move_pages;
    echo "============executing thp_page_migration_and_parallel/run_non_thp_test.sh================"
    ./run_non_thp_test.sh
    echo "============executing thp_page_migration_and_parallel/run_non_thp_2mb_page_test.sh================"
    ./run_non_thp_2mb_page_test.sh
    echo "============executing thp_page_migration_and_parallel/run_split_thp_test.sh================"
    ./run_split_thp_test.sh
    echo "============executing thp_page_migration_and_parallel/run_thp_test.sh================"
    ./run_thp_test.sh
    cd ..
    
    # generate plots
    cd plot_generator
    python thp_migration_bw_cmp.py
    cd ..

    # push this configuration data to repository
    # echo "user" | sudo -S su -c "./push_to_github.sh 'microbenchmark performance data for ${CONFIGURATION_NAMES[$i]}'" vimal

done

trap "./cleanup.sh; exit" INT

sudo sysctl kernel.numa_balancing=1
