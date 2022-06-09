from stats import stats
import matplotlib.pyplot as plt
import seaborn as sns
from matplotlib.pyplot import figure
import matplotlib as mpl
import math
import csv
import pandas as pd
import os.path

# figure(figsize=(24, 18), dpi=80)

# Generates three plots:
# (i) Show the improvement in Native-THP migration when using PMEM-optimization
# (ii) Show the improvement in Split-THP migration when using PMEM-optimization
# (iii) Show the improvement in the Exchange-concurrent page migration when using PMEM-optimization
# X-axis will be number of pages, Y-axis will be throughtput in MBps
# In each of the plots there will be 6 lines representing the data for PMEM-optimized/non-pmem-optimized for each of the 1,2 and 4 threads.

def main():
    # X-axis is the number of pages
    # Y-axis is the page migration bandwidth in MB/Sec
    # There will be a line for mt[1,2,4]-exchange, mt[1,2,4]-concurrent, mt[1,2,4]-native_thp, mt[1,2,4]-split_thp, pmem_optimization
    base_dir = "/home/vimal/nimble_experiment/nimble_page_management_userspace/microbenchmarks/plot_generator"
    file_name_templates = [
            base_dir + "/" + "../thp_page_migration_and_parallel/stats_thp/mt_{0}_2mb_page_order_{1}_{2}",
            base_dir + "/" + "../thp_page_migration_and_parallel/stats_split_thp/mt_{0}_split_thp_2mb_page_order_{1}_{2}",            
            base_dir + "/" + "../exchange_page_migration/stats_2mb/mt_{0}_page_order_{1}_exchange_batch_{2}",
            base_dir + "/" + "../exchange_page_migration/stats_2mb/seq_{0}_page_order_{1}_exchange_batch_{2}"
    ]
    migration_mechanism_name = [
        "native THP",
        "split THP",
        "exchange THP",
        "exchange THP",
    ]
    thread_counts=[1,2,4]
    page_orders = [i for i in range(0, 10)]

    df = pd.DataFrame(columns=["migration_mechanism", "thread_cnt", "page_cnt", "pmem-optimized", "bandwidth(MBps)"])
    row_cnt = 0
    # construct a data frame
    for file_name_template_id in range(len(file_name_templates)):
        for thread_cnt in thread_counts:
            for page_order in page_orders:
                for pmem_optimized in ["pmem_optimized", "not_pmem_optimized"]:
                    file_name = file_name_templates[file_name_template_id].format(thread_cnt, page_order, pmem_optimized)
                    if(not os.path.isfile(file_name)):
                        continue
                    stats_obj = stats(file_name)
                    total_migrated_MBytes = (1<<page_order)*(1<<21)/(1<<20)
                    if(migration_mechanism_name[file_name_template_id]=="exchange THP"):
                        total_migrated_MBytes *= 2
                    total_seconds = stats_obj.average_stats["Total_nanoseconds"]/(1e9)
                    bandwidth = (total_migrated_MBytes/total_seconds)
                    df.loc[row_cnt] = [migration_mechanism_name[file_name_template_id], thread_cnt, 1<<page_order, "pmem optimized" if pmem_optimized=="pmem_optimized" else "baseline", bandwidth]
                    row_cnt+=1

    df.to_csv("summarized_microbench_results.csv")

    sns.set_context('paper')
    # generate plot-1
    for plot_id in range(3):
        df_native_thp = df[df["migration_mechanism"]==migration_mechanism_name[plot_id]]
        df_native_thp = df_native_thp.rename(columns={"thread_cnt": "Thread Count", "pmem-optimized": "Migration Mechanism"})
        df_native_thp = df_native_thp.replace({"pmem optimized" : "NT+RPDAA"})
        # print(df.head())
        # sns.set(rc={'figure.figsize':(12,8)})
        # sns.color_palette("cubehelix", as_cmap=True)
        ax=sns.lineplot(data=df_native_thp, x='page_cnt', y='bandwidth(MBps)', hue='Thread Count', style='Migration Mechanism', palette=['r', 'g', 'b'], linewidth=2.5)
        ax.get_xaxis().set_minor_locator(mpl.ticker.AutoMinorLocator())
        ax.get_yaxis().set_minor_locator(mpl.ticker.AutoMinorLocator())
        ax.grid(b=True, which='major', color='w', linewidth=1.25)
        ax.grid(b=True, which='minor', color='w', linewidth=0.75)
        ax.set_xlabel("Number of Pages")
        ax.set_ylabel("Bandwidth(MBps)")
        # ax.set_title("{0} comparison.png".format(migration_mechanism_name[plot_id]))
        sns.move_legend(ax, "lower center", bbox_to_anchor=(0.5, 1), ncol=2, title=None, frameon=False)
        plt.tight_layout()
        plt.savefig('plots_output/{0} comparison.png'.format(migration_mechanism_name[plot_id]))
        plt.close()

main()