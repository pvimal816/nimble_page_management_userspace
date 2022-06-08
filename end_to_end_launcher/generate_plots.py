# construct a data frame having following columns
# benchmark_name, migration_mechanism, execution_time, page_migration_throughput(MB/cycles), nr_pages_migrated

import pandas as pd
import seaborn as sns
import matplotlib as mpl
import matplotlib.pyplot as plt
import os, sys

def main():
    if(len(sys.argv)!=2):
        print("Please provilde exactly one argument representing the csv file containing the result data.\n");
        sys.exit(-1)
    df = pd.read_csv(sys.argv[1])
    df["Average Execution Time(sec)"] = df["average_execution_time(ms)"]/1000;
    df["Benchmarks"] = df["benchmark_name"]
    benchmarks = df["Benchmarks"].unique()
    migration_mechanisms = df["migration_mechanism"].unique()
    sns.set_style("whitegrid")
    # sns.set_context("paper")
    ax = sns.barplot(x="Benchmarks", y="Average Execution Time(sec)", hue="migration_mechanism", data=df)
    sns.move_legend(ax, "lower center", bbox_to_anchor=(.5, -0.50), ncol=3, title=None, frameon=False)
    
    for container_id in range(len(ax.containers)):
        ax.bar_label(ax.containers[container_id],
            labels=[
                f'{x: 0.0f}' for x in
                df[df["migration_mechanism"]==migration_mechanisms[container_id]]["migration_bandwidth(MB/GCycles)"]
            ],
            rotation=0,
            fontsize=6
        )

    plt.tight_layout()
    plt.savefig(sys.argv[1].split(".csv")[0] + ".png")
    plt.close()

main()
