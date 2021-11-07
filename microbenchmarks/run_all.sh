# turnoff autonuma
sudo sysctl kernel.numa_balancing=0

# run concurrent page migration benchmarks
cd concurrent_page_migration;
make non_thp_move_pages;
make thp_move_pages;
echo "============executing concurrent_page_migration/run_non_thp_test.sh================"
./run_non_thp_test.sh
echo "============executing concurrent_page_migration/run_thp_test.sh===================="
./run_thp_test.sh
cd ..

run exchange page migration benchmark
cd exchange_page_migration
make non_thp_move_pages;
make thp_move_pages;
echo "============executing exchange_page_migration/run_non_thp_test.sh================"
./run_non_thp_test.sh
echo "============executing exchange_page_migration/run_thp_test.sh===================="
./run_thp_test.sh
cd ..

# run parallel and native thp page migration benchmark
# cd thp_page_migration_and_parallel
# make non_thp_move_pages;
# make thp_move_pages;
# echo "============executing thp_page_migration_and_parallel/run_non_thp_test.sh================"
# ./run_non_thp_test.sh
# echo "============executing thp_page_migration_and_parallel/run_non_thp_2mb_page_test.sh================"
# ./run_non_thp_2mb_page_test.sh
# echo "============executing thp_page_migration_and_parallel/run_split_thp_test.sh================"
# ./run_split_thp_test.sh
# echo "============executing thp_page_migration_and_parallel/run_thp_test.sh================"
# ./run_thp_test.sh
# cd ..
