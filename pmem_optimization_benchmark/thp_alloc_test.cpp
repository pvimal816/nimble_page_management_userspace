#include <sys/mman.h>
#include <cstdio>
#include <cstdlib>
#include <cstring>

int main(){
    size_t buffer_size = (1UL<<33);
    char* page_base = (char*) aligned_alloc((1UL<<21), buffer_size);
    madvise(page_base, buffer_size, MADV_HUGEPAGE);
    memset(page_base, 0xff, buffer_size);
    while(1);
    return 0;
}