#!/bin/bash

if [[ "x$1" == "x" ]]; then
	echo "Need to specify a folder"
	exit
fi

FOLDER=$1

BENCHS="503.postencil  551.ppalm  553.pclvrleaf  555.pseismic  556.psp  559.pmniGhost  560.pilbdc  563.pswim  570.pbt  graph500-omp"
CONFIGS="all-remote-access non-thp-migration thp-migration opt-migration exchange-pages all-local-access"
#CONFIGS="concur-only-opt-migration concur-only-exchange-pages"

BENCHS="503.postencil"
CONFIGS="all-local-access pmem-optimized exchange-pages basic-exchange-pages thp-migration opt-migration all-remote-access"

echo "benchmark_name,migration_mechanism,average_execution_time(ms),execution_time_deviation"
for C in ${CONFIGS}; do
	if test "$(find ${FOLDER}/*/*GB-${C}* -name '*cycles' -print -quit 2>/dev/null)"; then
		for B in ${BENCHS}; do
			#echo "${C} "
			#grep "cycles:" ${FOLDER}/${B}/*GB-${C}*/*cycles | cut -f 2 -d" " | awk -v config=${C} '{printf("%s %s\n",config, $0)}'
			AVG=`grep "cycles:" ${FOLDER}/${B}/*GB-${C}*/*cycles | cut -f 2 -d" " | awk '{n += 1; sum += int($1); sumsq += int($1)^2} END {stddev=sqrt((sumsq - sum^2/n)/n);printf("%.2f",sum/n)}'`
			STDDEV=`grep "cycles:" ${FOLDER}/${B}/*GB-${C}*/*cycles | cut -f 2 -d" " | awk '{n += 1; sum += int($1); sumsq += int($1)^2} END {stddev=sqrt((sumsq - sum^2/n)/n);printf("%.2f",stddev)}'`
			echo "${B},${C},${AVG},${STDDEV}"
		done
	fi
done
