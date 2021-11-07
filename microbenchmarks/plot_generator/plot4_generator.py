from stats import stats
import matplotlib.pyplot as plt
import seaborn as sns

# TODO update file paths. Currently this file is just a copy of Plot3_generator.py

def main():

    # number of pages
    page_count = [i for i in range(0, 10)]
    
    # single threaded base page migration
    base_page_migration = [
        (1<<i)*1e9/((1<<18)*stats("../thp_page_migration_and_parallel"
            + "/stats_4kb"
            + "/mt_1_4kb_page_order_{0}".format(i)).
        average_stats["Total_cycles"]) for i in page_count
    ]

    # mt=4, non-concurrent, 4KB pages
    four_thread_concur_base_page = [
        (1<<i)*1e9/((1<<18)*stats("../concurrent_page_migration"
            + "/stats_4kb"
            + "/mt_4_page_order_{0}_batch".format(i)).
        average_stats["Total_cycles"]) for i in page_count
    ]
    
    # mt=4 concurrent, 4KB pages
    four_thread_concur_exchange_base_page = [
        (1<<i)*1e9/((1<<18)*stats("../exchange_page_migration"
            + "/stats_4kb"
            + "/mt_4_page_order_{0}_exchange_batch".format(i)).
        average_stats["Total_cycles"]) for i in page_count
    ]
    
    # single threaded native thp migration
    thp_migration = [
        (1<<i)*1e9/((1<<9)*stats("../thp_page_migration_and_parallel"
            + "/stats_thp"
            + "/mt_1_2mb_page_order_{0}".format(i)).
        average_stats["Total_cycles"]) for i in page_count
    ]

    # mt=4, non-concurrent, THP pages
    four_thread_concur_thp_page = [
        (1<<i)*1e9/((1<<9)*stats("../concurrent_page_migration"
            + "/stats_2mb"
            + "/mt_4_page_order_{0}_batch".format(i)).
        average_stats["Total_cycles"]) for i in page_count
    ]

    # mt=4, concurrent, THP pages
    four_thread_concur_exchange_thp_page = [
        (1<<i)*1e9/((1<<9)*stats("../exchange_page_migration"
            + "/stats_2mb"
            + "/mt_4_page_order_{0}_exchange_batch".format(i)).
        average_stats["Total_cycles"]) for i in page_count
    ]

    thp_data = {
        "pagecount": [],
        "bandwidth": [],
        "migration_type": []
    }

    thp_y_data = [thp_migration, four_thread_concur_thp_page, four_thread_concur_exchange_thp_page]
    thp_labels = ["THP Migration", "4-Thread Concur Migrate", "4-Thread Concur Exchange"]

    for j in range(0, len(thp_y_data)):
        for i in page_count:
            thp_data["pagecount"].append(1<<i)
            thp_data["bandwidth"].append(thp_y_data[j][i])
            thp_data["migration_type"].append(thp_labels[j])

    base_page_data = {
        "pagecount": [],
        "bandwidth": [],
        "migration_type": []
    }

    base_y_data = [base_page_migration, four_thread_concur_base_page, four_thread_concur_exchange_base_page]
    base_page_labels = ["Base Page Migration", "4-Thread Concur Migrate", "4-Thread Concur Exchange"]

    for j in range(0, len(base_y_data)):
        for i in page_count:
            base_page_data["pagecount"].append(1<<i)
            base_page_data["bandwidth"].append(base_y_data[j][i])
            base_page_data["migration_type"].append(base_page_labels[j])

    fig, axs = plt.subplots(nrows=2)
    axs[0].grid(True)
    axs[1].grid(True)
    sns.lineplot(data=thp_data, x="pagecount", y="bandwidth", hue="migration_type", ax=axs[0]).set(title="Figure 10: Throughput comparison of exchange THP page migration(4 threads)", xlabel="Number of Pages", ylabel="Throughput(GB/GCycles)")
    sns.lineplot(data=base_page_data, x="pagecount", y="bandwidth", hue="migration_type", ax=axs[1]).set(title="Figure 10: Throughput comparison of exchange base page migration(4 threads)", xlabel="Number of Pages", ylabel="Throughput(GB/GCycles)")
    plt.tight_layout()
    plt.savefig('Plot_4.png')

main()