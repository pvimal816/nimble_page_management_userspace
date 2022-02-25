from stats import stats
import matplotlib.pyplot as plt
import seaborn as sns

def main():

    # base_page_stats: list of bandwidth info (GB/billion cycles) for different number of threads
    x = [(1<<i) for i in range(0, 5)]
    
    base_page_stats = [
            (1e9)/((1<<18)*stats("../thp_page_migration_and_parallel"
                + "/stats_4kb"
                + "/mt_{0}_4kb_page_order_2".format(i))
            .average_stats["Total_cycles"]) for i in x
    ]   
    
    # thp_stats: list of bandwidth info (GB/billion cycles) for different number of threads
    thp_stat = [
            (1e9)/((1<<9)*stats("../thp_page_migration_and_parallel"
                + "/stats_thp"
                + "/mt_{0}_2mb_page_order_2".format(i))
            .average_stats["Total_cycles"]) for i in x
    ]

    # TODO: convert above lists to represent GB/sec cycles
    # reference: https://www.intel.com/content/www/us/en/embedded/training/ia-32-ia-64-benchmark-code-execution-paper.html

    fig, axs = plt.subplots(nrows=2)
    axs[0].grid(True)
    axs[1].grid(True)
    sns.lineplot(x=x, y=thp_stat, ax=axs[0]).set(title="THP (2MB)", xlabel="No. of threads", ylabel="GB/GCycles")
    sns.lineplot(x=x, y=base_page_stats, ax=axs[1]).set(title="Base Page (4KB)", xlabel="No. of threads", ylabel="GB/GCycles")
    plt.tight_layout()
    plt.savefig('Plot_2.png')
    
    pass

main()