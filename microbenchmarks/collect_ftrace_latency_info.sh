sudo sysctl kernel.numa_balancing=0;

cd thp_page_migration_and_parallel;
make non_thp_move_pages;
make thp_move_pages;

# cd /sys/kernel/debug/tracing;
echo 0 > /sys/kernel/debug/tracing/tracing_on;
echo function_graph > /sys/kernel/debug/tracing/current_tracer;

echo "============executing thp_page_migration_and_parallel/run_non_thp_test.sh================"

sudo sysctl vm.sysctl_enable_thp_migration=1;

echo 1 > /sys/kernel/debug/tracing/tracing_on; 
numactl -N 2 -m 7 ./thp_move_pages 1 st 2>./thp_verify/non_thp_2mb_page_order_9 1>/dev/null;
echo 0 > /sys/kernel/debug/tracing/tracing_on;

sudo sysctl vm.sysctl_enable_thp_migration=0;

cat /sys/kernel/debug/tracing/trace > run_split_thp_test.sh.trace;

sudo sysctl kernel.numa_balancing=1;