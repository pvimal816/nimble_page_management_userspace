
CC=g++

thp_move_pages: move_page_breakdown.cpp 
	$(CC) -o $@ $^ -lnuma
	sudo setcap "all=ep" $@