if [ ! -d all_config_temp_output ]; then
	mkdir all_config_temp_output
fi

# dram to dram
echo "====================DRAM to DRAM page migration======================"
export SOURCE_NODE=2
export SOURCE_CPU_NODE=2
export DESTINATION_NODE=3
./run_all.sh
cd plot_generator
# python3 plot2_generator.py
# cp Plot_2.png ../all_config_temp_output/dram_to_dram_Plot2.png
python3 plot4_perf_stats_table_generator.py > ../all_config_temp_output/dram_to_dram_plot4_perf_stats.txt
cd ..

# dram to pmem
echo "====================DRAM to PMEM page migration======================"
export SOURCE_NODE=2
export SOURCE_CPU_NODE=2
export DESTINATION_NODE=9
./run_all.sh
cd plot_generator
# python3 plot2_generator.py
# cp Plot_2.png ../all_config_temp_output/dram_to_pmem_Plot2.png
python3 plot4_perf_stats_table_generator.py > ../all_config_temp_output/dram_to_pmem_plot4_perf_stats.txt
cd ..

# pmem to dram
echo "====================PMEM to DRAM page migration======================"
export SOURCE_NODE=7
export SOURCE_CPU_NODE=2
export DESTINATION_NODE=3
./run_all.sh
cd plot_generator
# python3 plot2_generator.py
# cp Plot_2.png ../all_config_temp_output/pmem_to_dram_Plot2.png
python3 plot4_perf_stats_table_generator.py > ../all_config_temp_output/pmem_to_dram_plot4_perf_stats.txt
cd ..

# pmem to pmem
echo "====================PMEM to PMEM page migration======================"
export SOURCE_NODE=7
export SOURCE_CPU_NODE=2
export DESTINATION_NODE=9
./run_all.sh
cd plot_generator
# python3 plot2_generator.py
# cp Plot_2.png ../all_config_temp_output/pmem_to_pmem_Plot2.png
python3 plot4_perf_stats_table_generator.py > ../all_config_temp_output/pmem_to_pmem_plot4_perf_stats.txt
cd ..