[33mcommit 7a6db2dace78bbb901ffe279c9f0d07ea2317762[m[33m ([m[1;36mHEAD -> [m[1;32mmaster[m[33m, [m[1;31morigin/master[m[33m, [m[1;31morigin/HEAD[m[33m)[m
Author: Vimal Patel <vimalm@iisc.ac.in>
Date:   Thu Oct 21 08:50:45 2021 +0530

    DRAM to DRAM experiment 2 on chisel-3
    
    Socket 0 and socket 1 have PMEM dimms configured in AppDirect (fsdax) mode.
    Where as socket 1 and 2 have their PMEM dimms configured in AppDirect (devdax) mode.
    AutoNUMA was turned off before starting the experiment and the pages migrated from NUMA
    node 0 to NUMA node 1.

[33mcommit a2a2cb2a3025e2a72125e3ca81af12b597842421[m
Author: Vimal Patel <vimalm@iisc.ac.in>
Date:   Thu Oct 21 01:45:18 2021 +0530

    DRAM to DRAM migration stats on chisel-3

[33mcommit be467693d6194eb4c43bd73546bceabd34d70c34[m
Author: Vimal Patel <vimalm@iisc.ac.in>
Date:   Fri Oct 15 10:48:20 2021 +0530

    Turnoff AutoNUMA before taking measurements

[33mcommit e7ecaa25374f5811ca9efb860164087ed0863e8e[m
Author: Vimal Patel <vimalm@iisc.ac.in>
Date:   Thu Oct 14 16:03:13 2021 +0530

    Implement plot generators

[33mcommit 57d8d716af08a152f8df9059611f4c4efb015e9e[m
Author: Vimal Patel <vimalm@iisc.ac.in>
Date:   Wed Oct 13 17:04:03 2021 +0530

    take benchmark measurements for DRAM

[33mcommit 834921a68bd03db7524e513db5d396809d9e2e76[m
Author: Vimal Patel <vimalm@iisc.ac.in>
Date:   Wed Oct 13 12:32:36 2021 +0530

    implement plot generator

[33mcommit 26137257a5c4e86c6b22ca02ec05860437538623[m
Author: Vimal Patel <vimalm@iisc.ac.in>
Date:   Tue Oct 12 12:50:34 2021 +0530

    add benchmark stats

[33mcommit fbb7a8f52318678aa312c96b6deb505d306fb618[m
Author: Vimal Patel <vimalm@iisc.ac.in>
Date:   Sat Oct 9 16:46:36 2021 +0530

    Add benchmark results

[33mcommit 1d170512af9f263ca6fd91c42f183ac4bf7ff8e4[m
Author: Vimal Patel <vimalm@iisc.ac.in>
Date:   Thu Oct 7 19:03:57 2021 +0530

    Fix syscall numbers in exchange page and end to end launcher

[33mcommit e621a6387209daad810cce9fcfdf3dfc50411c26[m
Author: Zi Yan <zi.yan@normal.zone>
Date:   Thu Mar 28 21:57:34 2019 -0700

    Add end-to-end application launcher.
    
    Use graph500 as an example.
    
    Signed-off-by: Zi Yan <zi.yan@normal.zone>

[33mcommit fca1a1807af4040bd6ce4b6eeb13af4b9b1b92d2[m
Author: Zi Yan <zi.yan@normal.zone>
Date:   Mon Mar 18 01:09:03 2019 +0000

    microbenchmark: add exchange page microbenchmarks.
    
    Signed-off-by: Zi Yan <zi.yan@normal.zone>

[33mcommit 6dbe186093afba19995215e9988209d55ef21296[m
Author: Zi Yan <zi.yan@normal.zone>
Date:   Mon Mar 18 01:05:43 2019 +0000

    microbenchmark: rename folder so that one can find parallel page migration.
    
    Signed-off-by: Zi Yan <zi.yan@normal.zone>

[33mcommit 4c31bff7535fccf99a332be52120b9b3a5addff2[m
Author: Zi Yan <zi.yan@normal.zone>
Date:   Mon Mar 18 01:04:23 2019 +0000

    microbenchmark: add concurrent page migration.
    
    Signed-off-by: Zi Yan <zi.yan@normal.zone>

[33mcommit 07e20b0a1b5571fa35f0982d7916c1ff2ce422d9[m
Author: Zi Yan <zi.yan@normal.zone>
Date:   Sun Mar 17 19:46:13 2019 +0000

    better folder structure.
    
    Signed-off-by: Zi Yan <zi.yan@normal.zone>

[33mcommit 161d501220e6e664f7a7400a37671d7907fc3a7c[m
Author: Zi Yan <zi.yan@normal.zone>
Date:   Sun Mar 17 19:43:01 2019 +0000

    microbenchmark: add THP migration microbenchmark.
    
    Signed-off-by: Zi Yan <zi.yan@normal.zone>

[33mcommit a5119de4ee3fe8daba0a40715c126b016fdb1d2b[m
Author: Zi Yan <zi.yan@normal.zone>
Date:   Sat Mar 16 17:07:31 2019 -0700

    Initial README file.
    
    Signed-off-by: Zi Yan <zi.yan@normal.zone>
