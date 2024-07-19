#include <iostream>
#include <iomanip>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/time.h>
#include <stdint.h>
#include <time.h>
#include "sp12_macros.h"

using namespace std;
extern bool terminating;
extern uint64_t bad_alignment;
int daq_mpc_data_into_file(string mpc_data_fn, int iterations, bool only_read)
{
    int fd = device_d;
    uint64_t value;
    

    log_printf ("DAQ readout, file: %s, iterations: %d\n",
                mpc_data_fn.c_str(), iterations);

    uint32_t LB_MEM_SIZE = 0x10000; //size of loopback buffer in sp12, bytes
    uint32_t DATA_SIZE   = 0x800; //one transfer size
    uint32_t N_WRITES = (LB_MEM_SIZE / DATA_SIZE); // how many transfers for entire buffer
    uint32_t MEM_BASE = 0x100000; // 0x80000 // bytes
    uint64_t REG_BASE = 0x40ULL; // 0x40ULL // bytes
    uint32_t REG_MEM_BASE = 0x80000; // 0xc0000  bytes


    uint32_t saddr, j;
    int ch = REG_BANK_CH; // config register bank
    off_t pos;
    uint16_t read_buf[LB_MEM_SIZE/2];
    

    saddr = REG_MEM_BASE + (ch << 12) + (0x16 << 3) ;
    pos = (REG_BASE << 32) + saddr;
    mread(fd, &value, 8, pos);
    //    value &= 0x1ff;
    log_printf ("spy mem addr: %016llx  buf_size: %d\n", value, sizeof(read_buf));
    if (value < 0x1ff)
    {
        log_printf("spy memory not full\n");
        return 0; // memory is not yet written
    }


    // open data file
    FILE * out = fopen(mpc_data_fn.c_str(), "wb");
    FILE * outd = fopen("mpc_data_decoded.txt", "w");

    //    saddr = REG_MEM_BASE + (ch << 12) + (0x11 << 3); // delay register

    //    value = 86 + (272 << 7) + (1 << 16); // set delays and l1a_en (local run works)
    //    mwrite(fd, &value, 8, saddr);


    // reset spy memory address
    //    if (!only_read)
//    {
//        // form address {chamber[6], sel[2], addr[7], 3'b0}
//        saddr = REG_MEM_BASE + (ch << 12); // reset register has address 0

//        value = 0;
//        mread(fd, &value, 8, saddr);
//        ov = value;

//        value |= 4ULL; // set reset bit
//        mwrite(fd, &value, 8, saddr);

//        mwrite(fd, &ov, 8, saddr);
//    }

    //for (int i = 0; i < iterations; i++)
    {

        // poll spy memory address until memory is full
        saddr = REG_MEM_BASE + (ch << 12) + (0x16 << 3) ;
        pos = (REG_BASE << 32) + saddr;

		//        uint64_t old_spy_addr = 0;
//        do
//        {
//            old_spy_addr = value;
//            mread(fd, &value, 8, pos);
//            value &= 0x1ff;
//            if (value != old_spy_addr)
//                log_printf("spy addr: %x\n", value);
//            if (terminating) break;

//        } while (value < 0xff /*0x1ff*/);

        // read memory address counter
//        mread(fd, &value, 8, pos);
//        value &= 0x1ff;

        log_printf ("reading spy mem,  pointer:     %x\n", value);

        bzero (read_buf, sizeof(read_buf));
        // read spy memory into buffer
        for ( j = 0; j < N_WRITES; j++)
        {
            off_t pos = (REG_BASE << 32) + MEM_BASE + j * DATA_SIZE;
            mread(fd, &(read_buf[j * DATA_SIZE/2]), DATA_SIZE, pos);
        }

        // reset spy memory address
        // form address {chamber[6], sel[2], addr[7], 3'b0}
//        saddr = REG_MEM_BASE + (ch << 12); // reset register has address 0

//        value = 4; // set reset bit
//        mwrite(fd, &value, 8, saddr);

//        value = 0; // remove reset bit
//        mwrite(fd, &value, 8, saddr);



        if (/*event_data || */only_read)
        {
            //            printf("found data at addr: %x\n", event_addr);
            // dump buffer into file
            fwrite(read_buf, 1, sizeof(read_buf), out);
            //            break;
        }

        //if (terminating) break;
        //set_progress (i*100/iterations);
    }

    log_printf ("finished\n");

    fclose (out);
    fclose (outd);
    //set_progress (100);
    return 0;
}

void hmt_rate_monitor()
{
    uint64_t sum_val;
    int si = 0;
    int sect_rate[13];
    uint64_t hmt_rate[13][3];

    while (1)
    {
        sum_val = 0;

        for (int di = 0; di < 13; di++)
        {
            sect_rate[di] = 0;
            if (devices_d[di] >= 0)
            {

                int fd = devices_d[di];
                // read HMT rates
                mread (fd, &hmt_rate[di][0], 8, 0xB63C0);
                mread (fd, &hmt_rate[di][1], 8, 0xB63B8);
                hmt_rate[di][2] = hmt_rate[di][1] >> 26;
                for (int j = 0; j < 3; j++) hmt_rate[di][j] &= 0x3ffffffULL;

                for (int j = 0; j < 3; j++)
                {
                    sum_val += hmt_rate[di][j];
                    sect_rate[di] += hmt_rate[di][j];
                }
            }
        }

        usleep(1000000);
//        log_printf ("HMT = %8d", sum_val);
//        for (int di = 0; di < 12 ; di++) log_printf ("%8d ", (int)sect_rate[di]);
        log_printf ("loose = ");
        for (int di = 0; di < 12 ; di++) log_printf ("%8d ", (int)hmt_rate[di][0]);
        log_printf ("\n");

        log_printf ("nomin = ");
        for (int di = 0; di < 12 ; di++) log_printf ("%8d ", (int)hmt_rate[di][1]);
        log_printf ("\n");

        log_printf ("tight = ");
        for (int di = 0; di < 12 ; di++) log_printf ("%8d ", (int)hmt_rate[di][2]);
        log_printf ("\n");

        fflush(stdout);
        si = (si+1)%4;
        if (terminating)
        {
            terminating = false;
            return;
        }
    }
}

void cosmics_rate_monitor()
{
    uint64_t sum_val, track [3];
    int si = 0;
	int sect_rate[13];
    //char spin[4][4] = {"-", "\\", "|", "/"};
    while (1)
    {
        sum_val = 0;

        for (int di = 0; di < 13; di++)
        {


			sect_rate[di] = 0;
            if (devices_d[di] >= 0)
            {

                int fd = devices_d[di];
                //mread(fd, &value, 8, 0x000B6280);
                mread(fd, &track[0], 8, 0x000B61B8); // track 0
                mread(fd, &track[1], 8, 0x000B61E0); // track 1
                mread(fd, &track[2], 8, 0x000B6208); // track 2
                for (int j = 0; j < 3; j++)
                {
                    track[j] >>= 32;
                    track[j] &= 0x3ffffffULL;
                    sum_val += track[j];
					sect_rate[di] += track[j];
                }
                //if (value > 100ULL)
//                    log_printf ("unit: %02d rate: %d\n", di, value);
            }
        }


        usleep(1000000);
//        log_printf("\r%s     ", spin[si]);
        log_printf ("rates = %8d", sum_val);
		for (int di = 0; di < 12; di++)	log_printf ("%8d ", sect_rate[di]);
		log_printf ("\n");
        fflush(stdout);
        si = (si+1)%4;
        if (terminating)
        {
            terminating = false;
            return;
        }
    }
}



#ifdef MPC_DATA_ANAL
// check for relevant events
bool event_data = false;
int event_addr = 0;
for ( j = 0; j < 16*16; j+=0x10)
{
    if ((read_buf[j] & 0x8000) == 0x8000)
    {
        // found frame0 of MPC0 fiber 0
        if (j != 0x80)
        {
            sprintf(line, "found frame0 at %x\n", j);
            fprintf(outd, "%s", line);
            printf("%s", line);
        }
        break;
    }
}
if (j == 16*16)
{
    log_printf ("cannot find MPC 0 fiber 0 frame 0\n");
    if (!only_read) break;
}

uint16_t valid[2], half_strip[2], wiregroup[2], quality[2], cpattern[2], lr[2];
uint16_t valid0[2], half_strip0[2], wiregroup0[2], quality0[2], cpattern0[2], lr0[2];
uint16_t bt_rank[4], bt_phi[4], bt_dphi1[4], bt_dphi2[4], bt_th[4], bt_dth1[4], bt_dth2[4];
bzero (valid0, 4);
bzero (half_strip0, 4);
bzero (wiregroup0, 4);
bzero (quality0, 4);
bzero (cpattern0, 4);
bzero (lr0, 4);
uint16_t l1a_cnt;
for (int e = 0; e < 125; e++) // event loop
{
    for (int m = 0; m < 5; m++) // mpc loop
    {
        for (int f = 0; f < 8; f++) // fiber loop
        {
            int fiber_abs = m*8+f;
            if (((bad_alignment >> fiber_abs) & 1ULL) == 1ULL)
                continue; // skip fibers with bad alignment (missing BC0)

            for (int r = 0; r < 4; r++) // frame loop
            {
                w = e*16*16 + m*8 + f + r*64 + j; // word address
                uint16_t frame = read_buf[w];
                switch (r)
                {
                case 0:
                    half_strip[0] = frame & 0xff;
                    wiregroup[0] = (frame >> 8) & 0x7f;
                    if ((frame & 0x8000) != 0x8000)
                    {
                        sprintf(line, "l1a: %04x e: %03d m: %d f: %d bad frame0\n",
                                l1a_cnt, e, m, f);
                        fprintf(outd, "%s", line);
                        printf("%s", line);
                        bad_alignment |= (1ULL << fiber_abs); // mark this fiber as bad
                    }
                    break;
                case 1:
                    half_strip[1] = frame & 0xff;
                    wiregroup[1] = (frame >> 8) & 0x7f;
                    break;
                case 2:
                    quality[0] = frame & 0xf;
                    cpattern[0] = (frame >> 4) & 0xf;
                    lr[0] = (frame >> 8) & 1;
                    lr[1] = (frame >> 9) & 1;
                    valid[0] = (frame >> 10) & 1;
                    valid[1] = (frame >> 11) & 1;
                    break;
                case 3:
                    quality[1] = frame & 0xf;
                    cpattern[1] = (frame >> 4) & 0xf;
                    // decode chamber 0 spread over all fibers in frame 3
                    switch (f)
                    {
                    case 0:
                        wiregroup0[0] = (frame >> 8) & 0x7f;
                        break;
                    case 1:
                        wiregroup0[1] = (frame >> 8) & 0x7f;
                        break;
                    case 2:
                        half_strip0[0] = (frame >> 8) & 0x7f;
                        break;
                    case 3:
                        half_strip0[1] = (frame >> 8) & 0x7f;
                        break;
                    case 4:
                        quality0[0] = (frame >> 8) & 0xf;
                        lr0[0] = (frame >> 12) & 1;
                        valid0[0] = (frame >> 13) & 1;
                        half_strip0[0] |= (frame >> 7) & 0x80;
                        break;
                    case 5:
                        quality0[1] = (frame >> 8) & 0xf;
                        lr0[1] = (frame >> 12) & 1;
                        valid0[1] = (frame >> 13) & 1;
                        half_strip0[1] |= (frame >> 7) & 0x80;
                        break;
                    case 6:
                        cpattern0[0] = (frame >> 8) & 0xf;
                        break;
                    case 7:
                        cpattern0[1] = (frame >> 8) & 0xf;
                        break;
                    }
                    break;
                }

                int l1aw = e*16*16 + r*64 + 48 + j; // address of l1a counter
                l1a_cnt = read_buf[l1aw];
            }
            if (valid[1])
            {
                // found good segment
                sprintf(line, "l1a: %04x e: %03d m: %d c: %d hs: %03d wg: %03d q: %02d p: %02d lr: %d\n",
                        l1a_cnt, e, m, f+2, half_strip[1], wiregroup[1], quality[1], cpattern[1], lr[1]);
                fprintf(outd, "%s", line);
                printf("%s", line);
                //                        if (half_strip[1] == 0 && wiregroup[1] == 0)
                {
                    event_data = true;
                    event_addr = w*2;
                }
            }
            if (valid[0])
            {
                // found good segment
                sprintf(line, "l1a: %04x e: %03d m: %d c: %d hs: %03d wg: %03d q: %02d p: %02d lr: %d\n",
                        l1a_cnt, e, m, f+2, half_strip[0], wiregroup[0], quality[0], cpattern[0], lr[0]);
                fprintf(outd, "%s", line);
                printf("%s", line);
                //                        event_data = true;
                //                        event_addr = w*2;
            }
        }
        if (valid0[1]) //check chamber ID=0 only after cycling thru all fibers
        {
            // found good segment
            sprintf(line, "l1a: %04x e: %03d m: %d c: 1 hs: %03d wg: %03d q: %02d p: %02d lr: %d\n",
                    l1a_cnt, e, m, half_strip0[1], wiregroup0[1], quality0[1], cpattern0[1], lr0[1]);
            fprintf(outd, "%s", line);
            printf("%s", line);
            //                    event_data = true;
            //                    event_addr = w*2;
            valid0[1] = 0;
        }
        if (valid0[0])
        {
            // found good segment
            sprintf(line, "l1a: %04x e: %03d m: %d c: 1 hs: %03d wg: %03d q: %02d p: %02d lr: %d\n",
                    l1a_cnt, e, m, half_strip0[0], wiregroup0[0], quality0[0], cpattern0[0], lr0[0]);
            fprintf(outd, "%s", line);
            printf("%s", line);
            //                        event_data = true;
            //                        event_addr = w*2;
            valid0[0] = 0;
        }
    }

    // decode core outputs
    for (int r = 0; r < 4; r++) // frame loop
    {
        for (int s = 0; s < 2; s++) // 64-bit section loop
        {
            w = e*16*16 + r*64 + s*4 + 40 + j; // word address
            uint64_t section = *((uint64_t*)(&(read_buf[w])));
            switch (s)
            {
            case 0:
                bt_rank[r] = (section >> (3*12 + 3*7)) & 0x7fULL;
                bt_phi[r] = (section) & 0xfffULL;
                bt_dphi1[r] = (section >> 12) & 0xfffULL;
                bt_dphi2[r] = (section >> (2*12)) & 0xfffULL;
                bt_th[r] = (section >> (3*12)) & 0x7fULL;
                bt_dth1[r] = (section >> (3*12 + 7)) & 0x7fULL;
                bt_dth2[r] = (section >> (3*12 + 2*7)) & 0x7fULL;
                break;

            case 1:
                break;
            }
        }
        if (bt_rank[r] > 0)
        {
            sprintf (line, "l1a: %04x e: %03d rnk: %02x ph: %04d dphi1: %04d dphi2: %04d th: %03d dth1: %03d dth2: %03d\n",
                     l1a_cnt, e, bt_rank[r], bt_phi[r], bt_dphi1[r], bt_dphi2[r],  bt_th[r], bt_dth1[r], bt_dth2[r]);
            fprintf(outd, "%s", line);
            printf("%s", line);
        }
    }

}
#endif
