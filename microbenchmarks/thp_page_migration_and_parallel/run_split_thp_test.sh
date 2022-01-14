#!/bin/bash


PAGE_LIST=`seq 0 9`
COPY_METHOD="mt"
MULTI="1 2 4 8 16"

if [ ! -d thp_verify ]; then
	mkdir thp_verify
fi

if [ ! -d stats_split_thp ]; then
	mkdir stats_split_thp
fi
sudo sysctl vm.sysctl_enable_thp_migration=0

for I in `seq 1 5`; do
	echo "[7]=========starting measurement number $I.=========="
	for MT in ${MULTI}; do
		sudo sysctl vm.limit_mt_num=${MT}
		for METHOD in ${COPY_METHOD}; do
			if [[ "x${METHOD}" == "xmt" && "x${MT}" == "x1" ]]; then
				PARAM="st"
			else
				PARAM=${METHOD}
			fi
			for N in ${PAGE_LIST}; do
				NUM_PAGES=$((1<<N))

				echo "[7]NUM_PAGES: "${NUM_PAGES}", METHOD: "${PARAM}", BATCH: "${BATCH}", MT: "${MT}

				if [[ "x${I}" == "x1" ]]; then
					numactl -N 2 -m 7 ./thp_move_pages ${NUM_PAGES} ${PARAM} 2>./thp_verify/${METHOD}_${MT}_2mb_page_order_${N} | grep -A 3 "\(Total_cycles\|Test successful\)" > ./stats_split_thp/${METHOD}_${MT}_split_thp_2mb_page_order_${N}
				else
					numactl -N 2 -m 7 ./thp_move_pages ${NUM_PAGES} ${PARAM} 2>./thp_verify/${METHOD}_${MT}_2mb_page_order_${N} | grep -A 3 "\(Total_cycles\|Test successful\)" >> ./stats_split_thp/${METHOD}_${MT}_split_thp_2mb_page_order_${N}
				fi

				sleep 1
			done
		done
	done
done


sudo sysctl vm.sysctl_enable_thp_migration=1
