from stats import stats
import matplotlib.pyplot as plt

def main():
    # X-axis is the number of pages
    # Y-axis is the page migration bandwidth in MB/Sec
    # There will be a line for mt[1,2,4]-exchange, mt[1,2,4]-concurrent, mt[1,2,4]-native_thp, mt[1,2,4]-split_thp, pmem_optimization
    thread_counts = [1, 2 ,4]
    page_count = [1<<i for i in range(0, 10)]
    file_name_templates = [ "../concurrent_page_migration/stats_2mb/mt_{0}_page_order_{1}_no_batch",
                            "../exchange_page_migration/stats_2mb/mt_{0}_page_order_{1}_exchange_no_batch",
                            "../thp_page_migration_and_parallel/stats_thp/mt_{0}_2mb_page_order_{1}_not_pmem_optimized",
                            "../thp_page_migration_and_parallel/stats_split_thp/mt_{0}_split_thp_2mb_page_order_{1}_not_pmem_optimized",
                            "../thp_page_migration_and_parallel/stats_thp/mt_1_2mb_page_order_{1}_pmem_optimized"
                    ]
    
    thp_data = {
        "pagecount": [],
        "bandwidth": [],
        "migration_type": []
    }


main()