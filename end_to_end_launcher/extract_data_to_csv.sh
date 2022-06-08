#!/bin/bash

if [[ "x$1" == "x" ]]; then
	echo "Need to specify a folder"
	exit
fi

FOLDER=$1

BENCHS="503.postencil  551.ppalm  553.pclvrleaf  555.pseismic  556.psp  559.pmniGhost  560.pilbdc  563.pswim  570.pbt  graph500-omp"
CONFIGS="all-remote-access non-thp-migration thp-migration opt-migration exchange-pages all-local-access"
#CONFIGS="concur-only-opt-migration concur-only-exchange-pages"

BENCHS="503.postencil 504.polbm 553.pclvrleaf 555.pseismic"
CONFIGS="all-local-access pmem-optimized exchange-pages basic-exchange-pages thp-migration opt-migration all-remote-access"

echo "benchmark_name,migration_mechanism,average_execution_time(ms),execution_time_deviation,migration_bandwidth(MB/GCycles)"
for B in ${BENCHS}; do
	for C in ${CONFIGS}; do
		if test "$(find ${FOLDER}/*/*GB-${C}* -name '*cycles' -print -quit 2>/dev/null)"; then
			#echo "${C} "
			#grep "cycles:" ${FOLDER}/${B}/*GB-${C}*/*cycles | cut -f 2 -d" " | awk -v config=${C} '{printf("%s %s\n",config, $0)}'
			AVG=`grep "real time(ms):" ${FOLDER}/${B}/*GB-${C}*/*cycles | cut -f 3 -d" " | awk '{n += 1; sum += int($1); sumsq += int($1)^2} END {stddev=sqrt((sumsq - sum^2/n)/n);printf("%.2f",sum/n)}'`
			STDDEV=`grep "real time(ms):" ${FOLDER}/${B}/*GB-${C}*/*cycles | cut -f 3 -d" " | awk '{n += 1; sum += int($1); sumsq += int($1)^2} END {stddev=sqrt((sumsq - sum^2/n)/n);printf("%.2f",stddev)}'`
			# calculate average page migration throughput and latency
			avg_base_pages_exchanged=`grep "ExchangePages.*_nr_base_pages" ${FOLDER}/${B}/*GB-${C}*/*page_migration_stats_0 | cut -f 2 -d" " | awk '{n += 1; sum += int($1);} END {n/=2; printf("%.2f",sum/n)}'`
			avg_base_pages_migrated=`grep "PageMigrations_nr_base_pages" ${FOLDER}/${B}/*GB-${C}*/*page_migration_stats_0 | cut -f 2 -d" " | awk '{n += 1; sum += int($1);} END {n/=4; printf("%.2f",sum/n)}'`
			avg_time_taken=`grep "PageMigrations_ttl_time_taken" ${FOLDER}/${B}/*GB-${C}*/*page_migration_stats_0 | cut -f 2 -d" " | awk '{n += 1; sum += int($1);} END {n/=4; printf("%.2f",sum/n)}'`
			# echo "${B}-${C}: $avg_base_pages_exchanged, $avg_base_pages_migrated, $avg_time_taken"
			migration_bandwidth=$(echo "print(0 if (${avg_time_taken})==0 else (${avg_base_pages_exchanged}*2 + ${avg_base_pages_migrated})/${avg_time_taken}*(1e9)/256)" | python3)

			echo "${B},${C},${AVG},${STDDEV},${migration_bandwidth}"
		fi
	done
done
