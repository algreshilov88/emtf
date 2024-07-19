
#include <iostream>
#include <iomanip>
#include <string.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/time.h>
#include <stdint.h>
#include <stdio.h>
#include <time.h>
#include "sp12_macros.h"



// core link module addresses
extern bool terminating;
extern bool lb_stress;
using namespace std;

int core_link_phase_inc(int target);

int loopback_main(int th_dev, string dest, int iterations)
{
    // for test memory loopback
    uint32_t LB_MEM_SIZE = 0x10000; //size of loopback buffer, bytes
    uint32_t DATA_SIZE = 0x1000; //one transfer size
    uint32_t N_WRITES = (LB_MEM_SIZE / DATA_SIZE); // how many transfers for entire buffer
    // loopback module addresses
    uint32_t MEM_BASE = 0x00000;
    uint64_t REG_BASE = 0x00ULL;
    uint32_t check_mask = 0xffffffffULL;
    uint32_t invert_mask = 0;
    uint32_t latency = 0;
    //uint32_t pattern;

    if (dest.compare("inject_64") == 0)
    {
        LB_MEM_SIZE = 0x20000; //size of loopback buffer, bytes
        DATA_SIZE   = 0x800; //one transfer size
        N_WRITES = (LB_MEM_SIZE / DATA_SIZE); // how many transfers for entire buffer
        // loopback module addresses
        MEM_BASE = 0xc0000;
        REG_BASE = 0x40ULL;
        check_mask = 0x00ffffffULL;
		//        pattern =    0x00111111ULL;
        log_printf ("inject_64\n");
    }

    if (dest.compare("inject_32") == 0)
    {
        LB_MEM_SIZE = 0x20000; //size of loopback buffer, bytes
        DATA_SIZE   = 0x800; //one transfer size
        N_WRITES = (LB_MEM_SIZE / DATA_SIZE); // how many transfers for entire buffer
        // loopback module addresses
        MEM_BASE = 0xe0000;
        REG_BASE = 0x40ULL;
        check_mask = 0x00ffffffULL;
		//        pattern =    0x00222222ULL;
        log_printf ("inject_32\n");
    }

    if (dest.compare("mpc_spy") == 0)
    {
        LB_MEM_SIZE = 0x10000; //size of loopback buffer, bytes
        DATA_SIZE   = 0x800; //one transfer size
        N_WRITES = (LB_MEM_SIZE / DATA_SIZE); // how many transfers for entire buffer
        // loopback module addresses
        MEM_BASE = 0x100000;
        REG_BASE = 0x40ULL;
        check_mask = 0xffffffffULL;
		//        pattern =    0x33333333ULL;
        log_printf ("mpc_spy\n");
    }

    if (dest.compare("pt_mem_data") == 0)
    {
        LB_MEM_SIZE = 0x4000; //size of loopback buffer, bytes
        DATA_SIZE   = 0x800; //one transfer size
        N_WRITES = (LB_MEM_SIZE / DATA_SIZE); // how many transfers for entire buffer
        // loopback module addresses
        MEM_BASE = 0x140000;
        REG_BASE = 0x40ULL;
        check_mask = 0x0003ffffULL;
		//        pattern =    0x00034444ULL;
        log_printf ("pt mem data loopback\n");
    }

    if (lb_stress)
    {
        // reduce data size for stress test
        LB_MEM_SIZE = 8; //size of loopback buffer, bytes
        DATA_SIZE   = 8; //one transfer size
        N_WRITES = (LB_MEM_SIZE / DATA_SIZE);
    }
    struct timeval t0, t1, t2, t3;
    double loop_time = 0., wloop_time = 0., rloop_time = 0.;

    uint32_t write_buf[2][LB_MEM_SIZE/4];
    uint32_t read_buf[LB_MEM_SIZE/4];

    //uint32_t treg[2]; 
	uint32_t tregr[2] = {0,0};

    memset(write_buf, 0x0, LB_MEM_SIZE);
    memset(read_buf, 0x0, LB_MEM_SIZE);

    srandom(time(NULL));

    for (size_t i=0; i<DATA_SIZE/4; i++)
    {
        write_buf[0][i] = random();
        write_buf[1][i] = random();
    }

    int fd = th_dev;
    int mismatch_cnt = 0;

    //if (dest.compare("memory") == 0)
	if (0)
    {
        log_printf("register r/w test\n");
        //treg[0] = 0x12345678;
        //treg[1] = 0x98765432;

        // test reg 0 is now used for sync clk config
//        mwrite(fd, &treg[0], 4, REG_BASE+0xc);

//        mread(fd, &tregr[0], 4, REG_BASE+0xc);

        //log_printf("%08x\n", tregr[0]);

        mread(fd, &tregr[0], 4, REG_BASE+0x10); // read bc0 period and resync count
        uint32_t bc0_period = tregr[0] & 0xfff;
        uint32_t resync_count = (tregr[0] >> 12) & 0xfffff;
        log_printf("bc0 period: %d 0x%x\n", bc0_period, bc0_period);
        log_printf("Resync count: %d 0x%x\n", resync_count, resync_count);
    }

    log_printf("Start write/read loop...\n");

    double ms = LB_MEM_SIZE;
    double mb = 1 << 20;
    double ds;

    loop_time = 0;
    wloop_time = 0;
    rloop_time = 0;
    srand(765);
    int n;
    string spinner[] = {"|", "/", "-", "\\"};
    for (n = 0; n < iterations; n++)
    {
        uint32_t pat = 0xffffffff;
        for (size_t i=0; i<LB_MEM_SIZE/4; i++)
        {
		  write_buf[n&1][i] = rand(); // pattern;
		  //		  write_buf[n&1][i] = i + (n << 12); // pattern;
            pat = ~pat;
        }

//**********************WRITING*********************

        if (!lb_stress)
        {
	    gettimeofday(&t0, NULL);
            for (uint32_t j = 0; j < N_WRITES; j++)
            {
                mwrite(fd, &(write_buf[n&1][j * DATA_SIZE/4]), DATA_SIZE, MEM_BASE + j * DATA_SIZE);
            }
	    gettimeofday(&t1, NULL);
        }
//        if (dest.compare("inject_64") == 0 || dest.compare("inject_32") == 0)
//            core_link_phase_inc(0); //  this actually transfers data at 40 MHz from inject to spy
//        usleep(10000);
// *******************READING******************

//        if (!lb_stress)
        {
	  gettimeofday(&t2, NULL);
	  for (uint32_t j = 0; j < N_WRITES; j++)
	    {
	      off_t pos = MEM_BASE + j * DATA_SIZE;
	      mread(fd, &(read_buf[j * DATA_SIZE/4]), DATA_SIZE, pos);
	    }
	  gettimeofday(&t3, NULL);
	}

//        usleep(10000);

        wloop_time += ((t1.tv_sec+t1.tv_usec/1000000.) - (t0.tv_sec+t0.tv_usec/1000000.));
        rloop_time += ((t3.tv_sec+t3.tv_usec/1000000.) - (t2.tv_sec+t2.tv_usec/1000000.));

// ************************CHECKING**********************

        if (!lb_stress)
        {
            uint32_t xorr;
            for (size_t i = 0; i < LB_MEM_SIZE/4-latency*2; i++)
            {
                read_buf[i+latency] ^= invert_mask;

                xorr = (write_buf[n&1][i] ^ read_buf[i+latency]) & check_mask;
                if (xorr != 0)
                {
                    log_printf ("n: %05x i: %04lx w: %08x r: %08x e: %08x\n",
                                n, i, write_buf[n&1][i], read_buf[i+latency], xorr);
                    mismatch_cnt++;
                    if (mismatch_cnt > 200) goto eject;
                }
            }
        }

        if (n%100 == 0)
        {
            set_progress (n*100/iterations);
            cout << "\r" << spinner[(n/100)&3] << "   " << flush;
            if (terminating)
            {
                terminating = false;
                break;
            }
        }
    }

    set_progress (100);

    ds = n*ms/mb;

    loop_time = wloop_time + rloop_time;


    log_printf("Loopback size: %d bytes\n", LB_MEM_SIZE);
    log_printf("Write/Read cycles: %d times\n", n);
    log_printf("Execution time: %f sec\n", loop_time);
    log_printf("Wr. Rate: %f MB/sec\n", ds/wloop_time);
    log_printf("Wr. Rate: %f Mb/sec\n", 8.*ds/wloop_time);
    log_printf("Rd. Rate: %f MB/sec\n", ds/rloop_time);
    log_printf("Rd. Rate: %f Mb/sec\n", 8.*ds/rloop_time);
    log_printf("Av. Rate: %f MB/sec\n", 2.*ds/loop_time);
    log_printf("Av. Rate: %f Mb/sec\n", 2.*8.*ds/loop_time);

    goto eject;

    gettimeofday(&t0, NULL);
    for (int j = 0; j < iterations; j++)
    {
        mwrite(fd, &(write_buf[0][0]), DATA_SIZE, MEM_BASE);
    }
    gettimeofday(&t1, NULL);
    wloop_time = ((t1.tv_sec+t1.tv_usec/1000000.) - (t0.tv_sec+t0.tv_usec/1000000.));
    log_printf("Write cycles: %d times\n", iterations);
    log_printf("Execution time: %f sec\n", loop_time);
    log_printf("Wr. Rate: %f MB/sec\n", (float)(DATA_SIZE*iterations)/wloop_time/(float)(1<<20));
    log_printf("Wr. Rate: %f Mb/sec\n", 8.*(float)(DATA_SIZE*iterations)/wloop_time/(float)(1<<20));

    gettimeofday(&t2, NULL);
    for (int j = 0; j < iterations; j++)
    {
        off_t pos = (REG_BASE << 32) + MEM_BASE;
        mread(fd, &(read_buf[0]), DATA_SIZE, pos);
    }
    gettimeofday(&t3, NULL);

    rloop_time = ((t3.tv_sec+t3.tv_usec/1000000.) - (t2.tv_sec+t2.tv_usec/1000000.));
    log_printf("Read cycles: %d times\n", iterations);
    log_printf("Execution time: %f sec\n", loop_time);
    log_printf("Rd. Rate: %f MB/sec\n", (float)(DATA_SIZE*iterations)/rloop_time/(float)(1<<20));
    log_printf("Rd. Rate: %f Mb/sec\n", 8.*(float)(DATA_SIZE*iterations)/rloop_time/(float)(1<<20));

eject:

    log_printf("Mismatched dwords: %d\n", mismatch_cnt);

    return 0;
}
