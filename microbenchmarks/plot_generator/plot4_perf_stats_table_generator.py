import csv

def main():
    page_orders = [0, 2, 4, 9]
    # directory = "../thp_page_migration_and_parallel/stats_thp/"
    directory = "../exchange_page_migration/stats_2mb/"
    thread_counts = [1, 2, 4, 8, 16]
    for page_order in page_orders:
        print("page count: {}".format(1<<page_order))
        print("{0: <15}{1: <15}{2: <15}{3: <15}{4: <15}".format("thread_count","rpq_occupancy","wpq_occupancy","rpq_inserts","wpq_inserts"))
        for thread_count in thread_counts:
            method = 'seq'
            if thread_count!=1:
                method = 'mt'
            file_name = directory+"{}_{}_page_order_{}_exchange_no_batch_perf_stats".format(method, thread_count, page_order)
            # print("reading file {}".format(file_name))
            sum = []
            with open(file_name, 'r') as csvfile:
                csvreader = csv.reader(csvfile)
                fields = next(csvreader)
                sum = [0]*len(fields)
                sample_count=0
                for row in csvreader:
                    sample_count+=1
                    i=0
                    # print(sum)
                    for col in row:
                        try:
                            sum[i] += int(col)
                        except ValueError as e:
                            pass
                        except IndexError as e:
                            pass
                        i+=1
                print("{0: <15}".format(thread_count), end="")
                for i in range(1, len(sum)):
                    sum[i] /= sample_count
                    print("{0: <15}".format(sum[i]), end="")
                print("")

main()