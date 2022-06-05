make thp_move_pages;
SOURCE_NODE=2
SOURCE_CPU_NODE=2
DESTINATION_NODE=9
ENABLE_PMEM_OPTIMIZATION=0
sudo sysctl vm.limit_mt_num=1
sudo sysctl kernel.numa_balancing=0
export PATH=$PATH:/home/vimal/pmu-tools
for i in `seq 1 5`; do
    ocperf stat -e UNC_M_PMM_RPQ_INSERTS,UNC_M_PMM_WPQ_INSERTS numactl -N $SOURCE_CPU_NODE -m $SOURCE_NODE ./thp_move_pages 512 seq $SOURCE_NODE $DESTINATION_NODE $ENABLE_PMEM_OPTIMIZATION
done
sudo sysctl kernel.numa_balancing=1