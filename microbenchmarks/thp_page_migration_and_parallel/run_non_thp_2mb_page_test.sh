#!/bin/bash

export PATH=$PATH:/home/vimal/pmu-tools

if [[ -z "$SOURCE_NODE" ]]; then
	# default to DRAM to DRAM migration
	SOURCE_NODE=2
fi

if [[ -z "$SOURCE_CPU_NODE" ]]; then
	SOURCE_CPU_NODE=2
fi

if [[ -z "$DESTINATION_NODE" ]]; then
	# default to DRAM to DRAM migration
	DESTINATION_NODE=3
fi

PAGE_LIST=`seq 0 9`
COPY_METHOD="mt"
MULTI="1 2 4 8 16"

PERF_EVENT_LIST=("bandwidth(GB/s)" unc_m_pmm_rpq_occupancy_all_0 unc_m_pmm_wpq_occupancy_all_0 unc_m_pmm_rpq_inserts_0 unc_m_pmm_wpq_inserts_0)
PERF_EVENT_LIST_STR="bandwidth(GB/s),unc_m_pmm_rpq_occupancy_all_0,unc_m_pmm_wpq_occupancy_all_0,unc_m_pmm_rpq_inserts_0,unc_m_pmm_wpq_inserts_0"

if [ ! -d thp_verify ]; then
	mkdir thp_verify
fi

if [ ! -d stats_non_thp ]; then
	mkdir stats_non_thp
fi

for I in `seq 1 5`; do
	echo "[5]=========starting measurement number $I.=========="
	for MT in ${MULTI}; do
		sudo sysctl vm.limit_mt_num=${MT}
		for METHOD in ${COPY_METHOD}; do
			if [[ "x${METHOD}" == "xmt" && "x${MT}" == "x1" ]]; then
				PARAM="st"
			else
				PARAM=${METHOD}
			fi
			for N in ${PAGE_LIST}; do
				NUM_PAGES=$((512<<N))
				
				echo "[5]NUM_PAGES: "${NUM_PAGES}", METHOD: "${PARAM}", BATCH: "${BATCH}", MT: "${MT}
				
				if [[ "x${I}" == "x1" ]]; then
					ocperf stat -x, -o ocperf_temp_output.txt -e UNC_M_PMM_RPQ_OCCUPANCY.ALL,UNC_M_PMM_WPQ_OCCUPANCY.ALL,UNC_M_PMM_RPQ_INSERTS,UNC_M_PMM_WPQ_INSERTS numactl -N ${SOURCE_CPU_NODE} -m ${SOURCE_NODE} ./non_thp_move_pages ${NUM_PAGES} ${PARAM} ${SOURCE_NODE} ${DESTINATION_NODE} 2>./thp_verify/non_thp_2mb_page_order_${N} | grep -A 3 "\(Total_cycles\|Test successful\)" > ./stats_non_thp/${METHOD}_${MT}_non_thp_2mb_page_order_${N}
					echo $PERF_EVENT_LIST_STR > ./stats_non_thp/${METHOD}_${MT}_non_thp_2mb_page_order_${N}_perf_stats
				else
					ocperf stat -x, -o ocperf_temp_output.txt -e UNC_M_PMM_RPQ_OCCUPANCY.ALL,UNC_M_PMM_WPQ_OCCUPANCY.ALL,UNC_M_PMM_RPQ_INSERTS,UNC_M_PMM_WPQ_INSERTS numactl -N ${SOURCE_CPU_NODE} -m ${SOURCE_NODE} ./non_thp_move_pages ${NUM_PAGES} ${PARAM} ${SOURCE_NODE} ${DESTINATION_NODE} 2>./thp_verify/non_thp_2mb_page_order_${N} | grep -A 3 "\(Total_cycles\|Test successful\)" >> ./stats_non_thp/${METHOD}_${MT}_non_thp_2mb_page_order_${N}
					echo "" >> ./stats_non_thp/${METHOD}_${MT}_non_thp_2mb_page_order_${N}_perf_stats
				fi

				for i in `seq 0 4`; do
					line=$(cat ocperf_temp_output.txt | grep -i ${PERF_EVENT_LIST[$i]})
					splittedArr=(${line//,/ })
					currentValue=${splittedArr[0]}
					echo -n "$currentValue," >> ./stats_non_thp/${METHOD}_${MT}_non_thp_2mb_page_order_${N}_perf_stats
					# sums[$i]=$(echo "print(${sums[$i]}+$currentValue)" | python3)
					# sums[$i]=$((${sums[$i]}+$currentValue))
					# echo ${sums[$i]}
				done

				rm ocperf_temp_output.txt

				sleep 1
			done
		done
	done
done


