from stats import stats
import matplotlib.pyplot as plt

def main():
    base_pages_stats = stats("../thp_page_migration_and_parallel"
                            + "/stats_non_thp"
                            + "/mt_1_non_thp_2mb_page_order_0")
    
    split_thp_stats = stats("../thp_page_migration_and_parallel"
                            + "/stats_split_thp"
                            + "/mt_1_split_thp_2mb_page_order_0")
    
    native_thp_stats = stats("../thp_page_migration_and_parallel"
                            + "/stats_thp"
                            + "/mt_1_2mb_page_order_0")
    
    base_page_copy_time = base_pages_stats.average_stats["copy_page_cycles"]
    base_page_total_time = base_pages_stats.average_stats["Total_cycles"]
    
    split_thp_copy_time = split_thp_stats.average_stats["copy_page_cycles"]
    split_thp_total_time = split_thp_stats.average_stats["Total_cycles"]

    native_thp_copy_time = native_thp_stats.average_stats["copy_page_cycles"]
    native_thp_total_time = native_thp_stats.average_stats["Total_cycles"]

    labels = ["512 Base Pages(THP equivalent)", "Split 1 THP Migration", "Transparent Huge Page"]
    copy_times = [base_page_copy_time,
                split_thp_copy_time,
                native_thp_copy_time]
    total_time = [base_page_total_time,
                        split_thp_total_time,
                        native_thp_total_time]

    width = 0.5
    fig, ax = plt.subplots()
    ax.bar(labels, total_time, width, label="kernel activity time")
    ax.bar(labels, copy_times, width, label="copy time")

    ax.set_ylabel('Cycles')
    ax.set_title('Cost breakdown for base, split thp, and native thp')
    ax.legend()
    plt.savefig('Plot_1.png')

    pass

main()