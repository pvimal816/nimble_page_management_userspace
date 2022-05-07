from stats import stats
import matplotlib.pyplot as plt
import seaborn as sns
from matplotlib.pyplot import figure
import math

figure(figsize=(24, 18), dpi=80)

def main():
    # X-axis is the number of pages
    # Y-axis is the page migration bandwidth in MB/Sec
    # There will be a line for mt[1,2,4]-exchange, mt[1,2,4]-concurrent, mt[1,2,4]-native_thp, mt[1,2,4]-split_thp, pmem_optimization
    thread_counts = [   [1, 2 ,4],
                        [1, 2 ,4],
                        [1, 2 ,4],
                        [1, 2 ,4],
                        [1]
                    ]
    page_orders = [i for i in range(0, 10)]
    base_dir = "/home/vimal/nimble_experiment/nimble_page_management_userspace/microbenchmarks/plot_generator"
    file_name_templates = [ base_dir + "/" + "../concurrent_page_migration/stats_2mb/mt_{0}_page_order_{1}_no_batch",
                            base_dir + "/" + "../exchange_page_migration/stats_2mb/mt_{0}_page_order_{1}_exchange_no_batch",
                            base_dir + "/" + "../thp_page_migration_and_parallel/stats_thp/mt_{0}_2mb_page_order_{1}_not_pmem_optimized",
                            base_dir + "/" + "../thp_page_migration_and_parallel/stats_split_thp/mt_{0}_split_thp_2mb_page_order_{1}_not_pmem_optimized",
                            base_dir + "/" + "../thp_page_migration_and_parallel/stats_thp/mt_{0}_2mb_page_order_{1}_pmem_optimized"
                    ]
    migration_type_name_templates = [   "mt-{0}-concurrent",
                                        "mt-{0}-exchange",
                                        "mt-{0}-native_thp",
                                        "mt-{0}-split_thp",
                                        "mt-{0}-pmem_optimization"
                               ]
    thp_data = {
        "page_count": [],
        "bandwidth": [],
        "migration_type": []
    }

    for i in range(len(file_name_templates)):
        for j in range(len(thread_counts[i])):
            file_name_template = file_name_templates[i]
            thread_count = thread_counts[i][j]
            migration_type_name = migration_type_name_templates[i].format(thread_count)
            for page_order in page_orders:
                total_migrated_MBytes = (1<<page_order)*(1<<21)/(1<<20); # 2MB pages
                file_name = file_name_template.format(thread_count, page_order)
                if i<2:
                    file_name = file_name.replace("mt_1", "seq_1")
                total_seconds = stats(file_name).average_stats["Total_nanoseconds"]/(1e9)
                bandwidth = (total_migrated_MBytes/total_seconds)
                thp_data["page_count"].append(1<<page_order)
                thp_data["bandwidth"].append(bandwidth)
                thp_data["migration_type"].append(migration_type_name)

    # print(thp_data)
    sns.set(rc={'figure.figsize':(11.7,8.27)})
    sns.color_palette("cubehelix", as_cmap=True)
    fig, axs = plt.subplots(nrows=2)
    axs[0].grid(True)
    axs[1].grid(True)
    sns.lineplot(data=thp_data, x="page_count", y="bandwidth", hue="migration_type", style="migration_type", ax=axs[0]).set(title="Figure 10: Throughput comparison", xlabel="Number of Pages", ylabel="Throughput(MB/Sec)")
    sns.lineplot(data=thp_data, x="page_count", y="bandwidth", hue="migration_type", style="migration_type", ax=axs[1]).set(title="Figure 10: Throughput comparison", xlabel="Number of Pages", ylabel="Throughput(MB/Sec)")
    plt.tight_layout()
    plt.savefig('thp_migration_bw_comparison.png')

main()