#!/bin/bash

echo 'file mm/exchange_page.c -p' > /sys/kernel/debug/dynamic_debug/control
echo 'file mm/exchange.c -p' > /sys/kernel/debug/dynamic_debug/control
echo 'file mm/migrate.c -p' > /sys/kernel/debug/dynamic_debug/control

echo madvise > /sys/kernel/mm/transparent_hugepage/enabled
sudo sysctl kernel.numa_balancing=1
sudo sysctl kernel.reset_bandwidth_counters=1
sudo sysctl kernel.enable_page_migration_optimization_avoid_remote_pmem_write=0
sudo sysctl kernel.enable_nt_exchange_page=0
sudo sysctl kernel.enable_nt_page_copy=0