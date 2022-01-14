#!/bin/bash


PAGE_LIST=`seq 0 9`
COPY_METHOD="seq mt"
BATCH_MODE="batch no_batch"
MULTI="1 2 4 8 16"

if [ ! -d thp_verify ]; then
	mkdir thp_verify
fi

if [ ! -d stats_4kb ]; then
	mkdir stats_4kb
fi

for I in `seq 1 5`; do
	echo "[3]=========starting measurement number $I.=========="
	for MT in ${MULTI}; do
		sudo sysctl vm.limit_mt_num=${MT}
		for BATCH in ${BATCH_MODE}; do
			for METHOD in ${COPY_METHOD}; do
				PARAM=${METHOD}
				if [[ "x${METHOD}" == "xseq" && "x${MT}" != "x1" ]]; then
					continue
				fi
				if [[ "x${METHOD}" == "xmt" && "x${MT}" == "x1" ]]; then
					continue
				fi
				for N in ${PAGE_LIST}; do
					NUM_PAGES=$((1<<N))

					echo "[3]NUM_PAGES: "${NUM_PAGES}", METHOD: "${PARAM}", BATCH: "${BATCH}", MT: "${MT}

					if [[ "x${I}" == "x1" ]]; then
						numactl -N 2 -m 2 ./non_thp_move_pages ${NUM_PAGES} ${PARAM} ${BATCH} 2>./thp_verify/${METHOD}_${MT}_4kb_page_order_${N}_${BATCH} | grep -A 3 "\(Total_cycles\|Test successful\)" > ./stats_4kb/${METHOD}_${MT}_page_order_${N}_exchange_${BATCH}
					else
						numactl -N 2 -m 2 ./non_thp_move_pages ${NUM_PAGES} ${PARAM} ${BATCH} 2>./thp_verify/${METHOD}_${MT}_4kb_page_order_${N}_${BATCH} | grep -A 3 "\(Total_cycles\|Test successful\)" >> ./stats_4kb/${METHOD}_${MT}_page_order_${N}_exchange_${BATCH}
					fi

					sleep 5
				done
			done
		done
	done
done


