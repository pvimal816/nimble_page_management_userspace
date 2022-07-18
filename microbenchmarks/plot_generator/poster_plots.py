from stats import stats
import matplotlib.pyplot as plt
import seaborn as sns
from matplotlib.pyplot import figure
import matplotlib as mpl
import math
import csv
import pandas as pd
import os.path

def main():
    mem_config="dram to pmem"
    df = pd.read_csv("summarized_microbench_results.csv")
    df = df[(df["configuration"]==mem_config) & (df["migration_mechanism"]=="exchange THP")]
    # print(df)
    sns.set_context('poster', font_scale=0.7)
    for thread_count in [1, 2, 4]:
        current_df = df[df["thread_cnt"]==thread_count]
        current_df["Migration Mechanism"] = current_df.apply(lambda row: "Nimble-Exchange" if row.rpdaa==False and row.nt==False else 
            "RPDAA-NT" if row.rpdaa==True and row.nt==True else "RPDAA" if row.rpdaa==True else "NT", axis=1)
        current_df["Page Count(2MB)"] = current_df["page_cnt"]
        # print(current_df[current_df["Page Count(2MB)"]==1])
        ax=sns.lineplot(data=current_df, x="Page Count(2MB)", y="bandwidth(MBps)", hue="Migration Mechanism", style="Migration Mechanism")
        ax.get_xaxis().set_minor_locator(mpl.ticker.AutoMinorLocator())
        ax.get_yaxis().set_minor_locator(mpl.ticker.AutoMinorLocator())
        ax.grid(b=True, which='major', color='w', linewidth=1.25)
        ax.grid(b=True, which='minor', color='w', linewidth=0.75)
        ax.set_xlabel("Number of Pages")
        ax.set_ylabel("Bandwidth(MBps)")
        sns.move_legend(ax, "lower center", bbox_to_anchor=(0.5, 1), ncol=2, title=None, frameon=False)
        plt.tight_layout()
        plt.savefig('plots_output/poster_microbench_plot_mt_{0}.png'.format(thread_count))
        plt.close()
main()