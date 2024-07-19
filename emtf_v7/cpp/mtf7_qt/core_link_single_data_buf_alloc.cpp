#include <iostream>
#include <cstring>
#include <string>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/time.h>
#include "core_link.h"

#define LB_MEM_SIZE 0x10000 //size of loopback buffer in sp12, bytes
#define DATA_SIZE 0x1000 //one transfer size
#define N_WRITES       (LB_MEM_SIZE / DATA_SIZE) // how many transfers for entire buffer

#define CHIP_SIZE 0x2000000L // size of one RLDRAM chip in 18-bit words (32 MW)
#define CHIP_COUNT 16L // how many RLDRAM chips on board
#define RL_MEM_SIZE (CHIP_SIZE*CHIP_COUNT) //size of RLDRAM in 18-bit words (512 MW = 1GB)
// each 32-bit PC word contains one 18-bit RLDRAM word
#define RL_DATA_SIZE_B (RL_MEM_SIZE*4L) // size of memory data buffer in bytes
#define RL_ADDR_SIZE_B (RL_MEM_SIZE*2L) // size of address buffer for rldram, bytes
#define FW_DATA_SIZE_B 0x2000 // size of data buffer in firmware, bytes
#define FW_ADDR_SIZE_B 0x1000 // size of addr buffer in firmware, bytes

#define XFER_SIZE_B 0x400 // 0x800 // one transfer via core link, bytes
#define XFERS_FW_DATA (FW_DATA_SIZE_B/XFER_SIZE_B) // count of transfers per fw data buffer
#define XFERS_FW_ADDR (FW_ADDR_SIZE_B/XFER_SIZE_B) // count of transfers per fw addr buffer
#define RL_BUFS_ALL (RL_DATA_SIZE_B/FW_DATA_SIZE_B) // count of data&address buffers to fill = 0x40000
#define RL_BUFS (RL_BUFS_ALL)

// bits in RLDRAM control register
#define RLDRAM_ONE 0 // one chips according to address
#define RLDRAM_ALL 1 // all chips
#define RLDRAM_TERM 2 // chips that need internal terminators
#define RLDRAM_REFRESH 4 // enable refresh
#define RLDRAM_RESET 8 // set reset signal

// contents of MRTs, see RLDRAM3_registers.xlsx
#define MR0 0x10 // for 093E memory
//#define MR0 0x11 // for 093 memory
#define MR1 0x400e0

#define MR2_T1 0x80004 // training pattern 0101
#define MR2_T2 0x80005 // training pattern 0101+1010
#define MR2    0x80000 // normal operation


#define ODT_ON  0x40008
#define ODT_OFF 0x40000


extern bool terminating;
int core_link_phase_inc(int target);
int write_mrs(uint32_t cs, uint32_t code);
int rldram_detect_read_delays(bool det_wr);

bool rd_training = false;
extern int ptlut_rx_clk_delay_val;


int phase[2] = {0,0};
int reset_core_link(int fd, int endcap, int sector)
{
//    int fd = device_d;
    uint32_t value;
    // reset link
    value = 0;
    mwrite (fd, &value, 4, REG_BASE+0xc);
    usleep(10000);
    value = 1;
    mwrite (fd, &value, 4, REG_BASE+0xc);
    usleep(10000);

    phase[0] = 0;
    phase[1] = 0;
    // set control clock phase
//    for (int i = 0; i < 12; i++) core_link_phase_inc(1);
    // set core clock phase
//    for (int i = 0; i < 57; i++) core_link_phase_inc(0);

    log_printf("core link reset\n");

    // write endcap and sector
    uint32_t CORE_REG_MEM_BASE = 0x80000; // 0xc0000  bytes
    uint64_t CORE_REG_BASE = 0x40ULL; // 0x60ULL // bytes

    int ch = 45; // config register bank
    uint32_t saddr = CORE_REG_MEM_BASE + (ch << 12) + (0x11 << 3); // delay register

    off_t pos = (CORE_REG_BASE << 32) + saddr;
    uint64_t qvalue = 0;
    mread(fd, &qvalue, 8, pos);
    log_printf("trigger_config before:  %016llx\n", qvalue);

    qvalue &= 0xfffffffffffffff0ULL; // clear bits for endcap/sector
    endcap -= 1; // endcap starts from 0 in firmware
    qvalue |= (endcap & 1); // add endcap code
    sector -= 1; // sector numbers start from 0 in firmware
    qvalue |= ((sector & 7) << 1); // add sector
    log_printf("writing trigger_config: %016llx\n", qvalue);
    mwrite(fd, &qvalue, 8, saddr);

    qvalue = 0;
    mread(fd, &qvalue, 8, pos);
    log_printf("trigger_config after:   %016llx\n", qvalue);
    

    return 0;
}

int core_link_phase_inc(int target)
{
    std::string target_name[] = {"core", "control"};
    int fd = device_d;
    uint32_t value;
    // increment MMCM clock phase in core FPGA
    switch (target)
    {
        case 0: value = 3; break;
        case 1: value = 5; break;
        default: value = 1; break;
    }
    mwrite (fd, &value, 4, REG_BASE+0xc);
    usleep(10000);
    value = 1;
    mwrite (fd, &value, 4, REG_BASE+0xc);

    log_printf ("%s phase: %d\n", target_name[target].c_str(), phase[target]);
    phase[target]++;

    return 0;
}


uint64_t *data_buf = NULL;
uint32_t *addr_buf = NULL;

int write_rldram()
{
    core_link cl(device_d);
    int fd = device_d;
    uint64_t value;

    // module addresses
    uint32_t MEM_BASE_CL = 0x80000; //   bytes	wire pt_iddr_psen = control_reg[8];

    int ch = 45; // config register bank

    // form address {chamber[6], sel[2], addr[7], 3'b0}
    uint32_t saddr = MEM_BASE_CL + (ch << 12); // reset register has address 0
    uint32_t MEM_BASE_PT_D = 0x140000; // pt data buffer
    uint32_t MEM_BASE_PT_A = 0x142000; // pt address buffer

    // reserve buffers for tests
    // each 32-bit word contains one 18-bit word for RLDRAM
    if (data_buf == NULL)
    {
        data_buf = (uint64_t*) malloc(RL_DATA_SIZE_B);
        if (data_buf == NULL) {log_printf("data_buf: not enough memory\n"); return -1;}
    }

    if (addr_buf == NULL)
    {
        addr_buf = (uint32_t*) malloc(RL_ADDR_SIZE_B);
        if (addr_buf == NULL) {log_printf("addr_buf: not enough memory\n"); return -1;}
        memset (data_buf, 0, RL_DATA_SIZE_B);
        memset (addr_buf, 0, RL_ADDR_SIZE_B);

        // read from file
        if (1)
        {
            FILE* ptlut_in = fopen("/opt/madorsky/data/LUT_AlexFormat.dat", "rb");
            if (ptlut_in != NULL)
            {
                log_printf ("reading 0x%llx bytes from /opt/madorsky/data/LUT_AlexFormat.dat\n", RL_DATA_SIZE_B);
                size_t result = fread (data_buf, 1, RL_DATA_SIZE_B, ptlut_in);
                if (result != RL_DATA_SIZE_B) {log_printf ("reading failure, read bytes: 0x%llx\n", result);}
                fclose (ptlut_in);
            }
	    else 
	      {
		printf ("cannot open file: /opt/madorsky/data/LUT_AlexFormat.dat\n");
		return 0;
	      }
        }

        for (uint64_t i = 0; i < RL_ADDR_SIZE_B/4; i++)
        {
            if(1)
            {
                // just fill addresses for file contents
                addr_buf[i] = (i*2); // address progresses by 2 because two words at a time are written
            }
            if(0)
            {
                // random data, consequtive addr
                data_buf[i] = random() & 0x3ffff;
                value = random() & 0x3ffff;
                data_buf[i] |= (value << 32);
                addr_buf[i] = (i*2);// + 0x18000000; // address progresses by 2 because two words at a time are written
//            addr_buf[i] |= ((i << 27) & 0x18000000);
            }

            if(0)
            {
                // running 1
                data_buf[i] = (1ULL << ((i*2)%18)) | (1ULL << (((i*2+1)%18)+32));
//                data_buf[i] = (1ULL << ((i*2)%18));
//                data_buf[i] = (~data_buf[i]) & 0x0003ffff0003ffffULL;
                addr_buf[i] = (i*2); // address progresses by 2 because two words at a time are written
//            addr_buf[i] |= ((i << 27) & 0x18000000);
            }

            if(0)
            {
                // fixed value
                data_buf[i] = 0;
                addr_buf[i] = (i*2); // address progresses by 2 because two words at a time are written
            }

            if(0)
            {
                // address data, consequtive addr

                data_buf[i] = ((i*2)&0x3ffff) + (((i*2+1)&0x3ffff) << 32);
//                data_buf[i] = (((i*2)&0x1ff) << 9) + (((i*2+1)&0x1ff) << (32+9));
                addr_buf[i] = (i*2); // address progresses by 2 because two words at a time are written
//            addr_buf[i] |= ((i << 27) & 0x18000000);
//                addr_buf[i] |= ((i << 24) & 0x18000000);
            }

            if(0)
            {
                // quad switching test
                uint32_t id = i*2;
                uint32_t quad = (id >> 3) & 0x3;
                uint32_t low_a = (id & 7) | ((id >> 2) & 0x7fffff8); // in low address bits, remove two bits used for quad
                addr_buf[i] = (quad << 27) | low_a;
                data_buf[i] = (((addr_buf[i] >> 11) & 0x30000) + i*2); // data bits 17:16 contain quad #
                data_buf[i] = (((data_buf[i]+1) << 32) | data_buf[i]);
                data_buf[i] &= 0x0003ffff0003ffff;
            }

            if(0)
            {
                // chip switching test
                uint32_t id = i*2;
                uint32_t chip = (id >> 3) & 0xf;
                uint32_t low_a = (id & 7) | ((id >> 4) & 0x1fffff8); // in low address bits, remove 4 bits used for chip
                addr_buf[i] = (chip << 25) | low_a;
//                addr_buf[i] = ((i << 22) & 0x06000000) + i*2; // change chip every 8 words
                data_buf[i] = ((addr_buf[i] >> 9) & 0x30000) + i*2; // data bits 17:16 contain chip #
                data_buf[i] = (((data_buf[i]+1) << 32) | data_buf[i]);
                data_buf[i] &= 0x0003ffff0003ffff;
            }


            if(0)
            {
                // testing write timing with scope
                if (i == 0)
                {
                    addr_buf[i] = 0x18000000;
                }
                else if (i == 1)// || i == 2)
                {
                    addr_buf[i] = 0;
                }
                else
                    addr_buf[i] = 0x10000000;

                if (i == 1)
                {
    //                data_buf[i] = 0xffffffff00000000;
                    data_buf[i] = 0x00000000ffffffff;
                }
                else
                {
                    data_buf[i] = 0;
                }
            }

            if(rd_training)
            {
                // tranining pattern expected from RLDRAM
                data_buf[i] = 0x000155550002aaaa;
//                data_buf[i] = 0x0003ffff00000000;
                //zero out lower part of address
                addr_buf[i] = (i*2) & 0xfe000000UL;
            }

        }
    }


    if (rd_training) // training reading, just reserve buffers and quit
    {
//        memset (addr_buf, 0, RL_ADDR_SIZE_B);

        log_printf ("buffers reserved for training\n");
        return 0;
    }


    write_mrs(0x01010101, ODT_ON); // turn ODT on, only on one chip at the end of each quad

    uint32_t saddr_stat = MEM_BASE_CL + (ch << 12) + (0x11 << 3); // status register with busy bit
    uint64_t pos_stat = (REG_BASE << 32) + saddr_stat;

/*
    for (uint64_t i = 0; i < RL_ADDR_SIZE_B/4; i++)
    {

        data_buf[i] = ((i*2)&0x3ffff) + (((i*2+1)&0x3ffff) << 32);
        addr_buf[i] = 0x1a00000*2 + (i*2);// + 0x18000000; // address progresses by 2 because two words at a time are written
//        if (i == 0x3ff) data_buf[i] = 0x0000000200000001ULL;
//        if (i == 0x400) data_buf[i] = 0x0000000400000003ULL;

//        if (i == 0x7ff) data_buf[i] = 0x0000002200000011ULL;
//        if (i == 0x800) data_buf[i] = 0x0000004400000033ULL;
//            addr_buf[i] |= ((i << 27) & 0x18000000);
//                addr_buf[i] |= ((i << 24) & 0x18000000);
    }
*/


    for (int i = 0; i < RL_BUFS; i++)
    {

        // fill address buffer in FW
        for (int j = 0; j < XFERS_FW_ADDR; j++)
            mwrite(fd,
                   addr_buf + i*FW_ADDR_SIZE_B/4 + j*XFER_SIZE_B/4,
                   XFER_SIZE_B,
                   MEM_BASE_PT_A + j*XFER_SIZE_B);

//        while(1)
        {
            // fill data buffer in FW
            for (int j = 0; j < XFERS_FW_DATA; j++)
                mwrite(fd,
                       data_buf + i*FW_DATA_SIZE_B/8 + j*XFER_SIZE_B/8,
                       XFER_SIZE_B,
                       MEM_BASE_PT_D + j*XFER_SIZE_B);

            // send command
            value = 0x40; // set wr command bit
            mwrite(fd, &value, 8, saddr);
            value = 0; // remove
            mwrite(fd, &value, 8, saddr);
//            usleep(10000);
            if (terminating)
            {
                terminating = false;
                log_printf("terminating\n");
                break;
            }
        }

        do
        {
            // wait until not busy
            mread(fd, &value, 8, pos_stat);
        } while ((value >> 21) & 1ULL);

    }

    write_mrs(0xffffffff, ODT_OFF); // turn ODT off

    // need to enable REFRESH here


//    free (data_buf);
//    free (addr_buf);
    log_printf ("done\n");

    return 0;

}

uint32_t err_bits[16];

int read_rldram_random_addr(int iterations)
{
    int fd = device_d;
    uint64_t value;
    uint32_t *rand_addr;
    uint64_t *rb_data;
    uint32_t older_rand = 0, old_rand = 0, new_rand;
    uint32_t MEM_BASE_PT_D = 0x140000; // pt data buffer
    uint32_t MEM_BASE_PT_A = 0x142000; // pt address buffer
    int ch = 45; // config register bank

    rand_addr = (uint32_t *)malloc(FW_ADDR_SIZE_B);
    rb_data   = (uint64_t *)malloc(FW_DATA_SIZE_B);

    // module addresses
    uint32_t MEM_BASE_CL = 0x80000; //   bytes
    uint32_t saddr = MEM_BASE_CL + (ch << 12); // reset register has address 0
    uint32_t saddr_stat = MEM_BASE_CL + (ch << 12) + (0x11 << 3); // status register with busy bit
    uint64_t pos_status = (REG_BASE << 32) + saddr_stat;
    uint64_t pos = (REG_BASE << 32) + MEM_BASE_PT_D;
    int err_count = 0;

    set_progress(0);

    for (int i = 0; i < iterations; i++)
    {
        // fill address buffer with random addresses
        for (int j = 0; j < FW_ADDR_SIZE_B/4; j++)
        {
            older_rand = old_rand;
            old_rand = new_rand;
get_another:
            new_rand = random() & 0x1ffffffe;
//            uint32_t chip = j & 0xf;
//            uint32_t addr = (j >> 3) & 0x1fffffe;
//            uint32_t chip = 15;
//            uint32_t addr = (j*2) & 0x1fffffe;
//            new_rand = (chip << 25) | addr;
            if (j > 0)
            {
                // make sure the new address does not hit same bank in same chip as old one
                // for 8-ns chips, just one old clock can be analyzed
                // for 10-ns chips, two clocks have to be analyzed
                uint32_t older_bank = older_rand & 0x1f;
                uint32_t older_chip = (older_rand >> 25) & 0xf;
                uint32_t old_bank = old_rand & 0x1f;
                uint32_t old_chip = (old_rand >> 25) & 0xf;
                uint32_t new_bank = new_rand & 0x1f;
                uint32_t new_chip = (new_rand >> 25) & 0xf;
                if (old_bank == new_bank && old_chip == new_chip) goto get_another;
//                if (older_bank == new_bank && older_chip == new_chip) goto get_another;
            }

            rand_addr[j] = new_rand;

        }

        // fill address buffer in FW
        for (int j = 0; j < XFERS_FW_ADDR; j++)
            mwrite(fd,
                   rand_addr + j*XFER_SIZE_B/4,
                   XFER_SIZE_B,
                   MEM_BASE_PT_A + j*XFER_SIZE_B);

        value = 0x80; // set rd command bit
        mwrite(fd, &value, 8, saddr);
        value = 0; // remove
        mwrite(fd, &value, 8, saddr);

        do
        {
            // wait until not busy
            mread(fd, &value, 8, pos_status);
        } while ((value >> 21) & 1ULL);


        memset(rb_data, 0x55, sizeof(rb_data));
        // read FW buffer
        for (int j = 0; j < XFERS_FW_DATA; j++)
            mread(fd,
                   rb_data + j*XFER_SIZE_B/8,
                   XFER_SIZE_B,
                   pos + j*XFER_SIZE_B);

        // now compare
        for (int j = 0; j < FW_DATA_SIZE_B/8; j++)
        {
            // get written data from global buffer, from random address
            uint64_t wd = data_buf[rand_addr[j]/2];
            // get data that were read from that random address
            uint64_t rd = rb_data[j];
            uint64_t xord = wd ^ rd;
            if (xord != 0)
            {
                if (err_count < 150)
                {
                    printf("j: %04x addr: %08x w: %016lx r: %016lx e: %016lx\n",
                               j, rand_addr[j], wd, rd, xord);
                }
                err_count++;
            }
        }

        if (terminating)
        {
            terminating = false;
            break;
        }
        set_progress((i+1)*100/iterations);
    }


    free (rand_addr);
    free (rb_data);
    log_printf("done\n");
    return 0;
}

int read_rldram(bool print_err)
{
    uint64_t *rdata_buf;
    core_link cl(device_d);
    int fd = device_d;
    uint64_t value;

    // module addresses
    uint32_t MEM_BASE_CL = 0x80000; //   bytes

    int ch = 45; // config register bank

    // form address {chamber[6], sel[2], addr[7], 3'b0}
    uint32_t saddr = MEM_BASE_CL + (ch << 12); // reset register has address 0
    uint32_t MEM_BASE_PT_D = 0x140000; // pt data buffer
    uint32_t MEM_BASE_PT_A = 0x142000; // pt address buffer

    // reserve buffers for tests
    // each 32-bit word contains one 18-bit word for RLDRAM
    rdata_buf = (uint64_t*) malloc(RL_DATA_SIZE_B);
    if (rdata_buf == NULL) {log_printf("rdata_buf: not enough memory\n"); return -1;}

    memset (rdata_buf, 0, RL_DATA_SIZE_B);

    // clean up data buffer memory first
//    mwrite(fd, rdata_buf, XFER_SIZE_B, MEM_BASE_PT_D);

    uint32_t saddr_stat = MEM_BASE_CL + (ch << 12) + (0x11 << 3); // status register with busy bit
    uint64_t pos_status = (REG_BASE << 32) + saddr_stat;
    uint64_t pos = (REG_BASE << 32) + MEM_BASE_PT_D;

    if (rd_training)
    {
//        memset (addr_buf, 0, RL_ADDR_SIZE_B);

    }
    else
    {

        for (uint64_t i = 0; i < RL_ADDR_SIZE_B/4; i++)
        {
//            addr_buf[i] = 0x7fc + ((i%4)*2);
//            addr_buf[i] = 0x802 - ((i%4)*2);
//            if (i % 5 == 0)
//                addr_buf[i] |= 0x18000000;
//            addr_buf[i] = (i*2);
        }

    }

//    write_mrs(0x01010101, 0x4000c); // 120 Ohm

    for (int i = 0; i < RL_BUFS; i++)
    {
        // fill address buffer in FW
        for (int j = 0; j < XFERS_FW_ADDR; j++)
            mwrite(fd,
                   addr_buf + i*FW_ADDR_SIZE_B/4 + j*XFER_SIZE_B/4,
                   XFER_SIZE_B,
                   MEM_BASE_PT_A + j*XFER_SIZE_B);


//        while(1)
        {
            // send command
            value = 0x80; // set rd command bit
            mwrite(fd, &value, 8, saddr);
            value = 0; // remove
            mwrite(fd, &value, 8, saddr);
//            usleep(10000);
            if (terminating)
            {
                terminating = false;
                break;
            }
        }

        do
        {
            // wait until not busy
            mread(fd, &value, 8, pos_status);
        } while ((value >> 21) & 1ULL);


        // read buffer
        for (int j = 0; j < XFERS_FW_DATA; j++)
            mread(fd,
                   rdata_buf + i*FW_DATA_SIZE_B/8 + j*XFER_SIZE_B/8,
                   XFER_SIZE_B,
                   pos + j*XFER_SIZE_B);

    }

//    write_mrs(0xffffffff, ODT_OFF);

    int64_t tot_words =  (int64_t)RL_BUFS * (int64_t)FW_DATA_SIZE_B/8;

    printf ("comparing %lx words\n", tot_words*2);
    int err_count = 0;

    // detect address shift
//    int ash = 0;
//    uint64_t xord = data_buf[2] ^ rdata_buf[1];
//    if (xord == 0) ash = 1;

    bzero(err_bits, sizeof(err_bits));
//    int64_t one_chip = tot_words/8;
    int64_t chipn;
    int chip_err[16];
    bzero(chip_err, sizeof(chip_err));



    for (int64_t i = 0; i < 2 *tot_words; i++)
    {
//        int low_addr = i & 0x7ff;
//        if (low_addr > 1 && low_addr < 0x7fa)
        {
            uint32_t wd = ((uint32_t*)data_buf)[i];
            uint32_t rd = ((uint32_t*)rdata_buf)[i];
            uint64_t xord = wd ^ rd;
            chipn = i / CHIP_SIZE;
            if (xord != 0)
            {
                if (err_count < 150 && print_err)
                {
                    printf("i: %08lx w: %08x r: %08x e: %08lx r_bin: ",
                               i, wd, rd, xord);
                    for (int y = 0; y < 18; y++) printf ("%d", (rd >> (17-y)) & 1);
                    printf ("\n");
                }
                chip_err[chipn] ++;
                err_count++;
                err_bits[chipn] |= xord;
            }
        }
    }

    if (print_err)
    {
        for (int i = 0; i < 16; i++)
            log_printf("chip: %02d errors: %9d bits: %06lx\n", i, chip_err[i], err_bits[i]);
        log_printf ("\n");
    }

    // need to enable REFRESH here

    free (rdata_buf);

    return err_count;

}

void iddr_phase_inc(bool det_wr, int inc_count)
{
    uint32_t MEM_BASE_CL = 0x80000;
    uint32_t ch = 45;
    uint32_t saddr = MEM_BASE_CL + (ch << 12); // control register has address 0

    uint64_t reg_dat = 0;
    uint64_t v = (uint64_t)inc_count;
    uint64_t rb;
    // prepare register value, all delays the same at this time
    for (int i = 0; i < 12; i++)
    {
        reg_dat |= (v << (i*5));
    }

    // program data bit delays
    uint32_t reg_start = det_wr ? 0x20 : 0x1a; // select wr or rd delay registers
    for (int i = 0; i < 6; i++)
    {
        uint64_t reg_addr = saddr + ((reg_start+i) << 3);
        mwrite(device_d, &reg_dat, 8, reg_addr);
    }

    // rx clk delay
    uint64_t reg_addr = saddr + (0x26 << 3);
    v = ptlut_rx_clk_delay_val;
    mwrite(device_d, &v, 8, reg_addr);


    // load new delays
    uint64_t val;
    val = (1ULL << 12);
    mwrite(device_d, &val, 8, saddr);
    val = 0;
    mwrite(device_d, &val, 8, saddr);

    // read back delays
    for (int i = 0; i < 6; i++)
    {
        uint64_t reg_addr = (REG_BASE << 32) + saddr + ((reg_start + i) << 3);
        mread(device_d, &rb, 8, reg_addr);
        if (rb != reg_dat)
            printf ("delay register mismatch: i: %d w: %016lx r: %016lx\n", i, reg_dat, rb);
    }


    inc_count++;
//    log_printf("delay tap count: %02d reg_start: %02x reg: %016llx rx_clk_del: %02d\n", inc_count, reg_start, reg_dat, ptlut_rx_clk_delay_val);

}

char best_rd_delay[4][18];


void set_dq_delays(bool det_wr)
{
    uint32_t MEM_BASE_CL = 0x80000;
    uint32_t ch = 45;
    uint32_t saddr = MEM_BASE_CL + (ch << 12); // control register has address 0

    uint64_t reg_dat[6] = {0,0,0,0,0,0};
    uint64_t reg_dat_rb[6] = {0,0,0,0,0,0};
    uint64_t v;

    // prepare register values with rd delays
    int w = 0, wp = 0;
    for (int i = 0; i < 4; i++) // quad loop
    {
        for (int j = 0; j < 18; j++) // bit loop
        {
           reg_dat[w] |= (((uint64_t)best_rd_delay[i][j]) << wp);
           wp += 5; // word part bit shift count
           if (wp >= 60)
           {
               wp = 0;
               w++; // word count
           }
        }
    }

    // program data bit delays
    uint32_t reg_start = det_wr ? 0x20 : 0x1a;
    for (int i = 0; i < 6; i++)
    {
        uint64_t reg_addr = saddr + ((reg_start + i) << 3);
        mwrite(device_d, &reg_dat[i], 8, reg_addr);
    }

    // rx clk delay
    uint64_t reg_addr = saddr + (0x26 << 3);
    v = ptlut_rx_clk_delay_val;
    mwrite(device_d, &v, 8, reg_addr);


    // load new delays
    uint64_t val;
    val = (1ULL << 12);
    mwrite(device_d, &val, 8, saddr);
    val = 0;
    mwrite(device_d, &val, 8, saddr);

    // read back delays
    for (int i = 0; i < 6; i++)
    {
        uint64_t reg_addr = (REG_BASE << 32) + saddr + ((reg_start + i) << 3);
        mread(device_d, &reg_dat_rb[i], 8, reg_addr);
        if (reg_dat_rb[i] != reg_dat[i])
            printf ("delay register mismatch: i: %d w: %016lx r: %016lx \n", i, reg_dat[i], reg_dat_rb[i]);
        for (int j = 0; j < 12; j++)
        {
            uint32_t dval = ((reg_dat[i] >> (j*5)) & 0x1f);
            printf ("%d ", dval);
        }
        printf("\n");
    }


    printf("dq delays set, rx_clk_del: %02d reg_start: %02x\n", ptlut_rx_clk_delay_val, reg_start);

}


int read_rldram_training(bool det_wr)
{
    uint64_t *rdata_buf;
    uint32_t *taddr_buf;
    core_link cl(device_d);
    int fd = device_d;
    uint64_t value;

    // module addresses
    uint32_t MEM_BASE_CL = 0x80000; //   bytes

    int ch = 45; // config register bank

    // form address {chamber[6], sel[2], addr[7], 3'b0}
    uint32_t saddr = MEM_BASE_CL + (ch << 12); // reset register has address 0
    uint32_t MEM_BASE_PT_D = 0x140000; // pt data buffer
    uint32_t MEM_BASE_PT_A = 0x142000; // pt address buffer

    // reserve buffers for tests
    // each 32-bit word contains one 18-bit word for RLDRAM
    rdata_buf = (uint64_t*) malloc(1024*16*8);
    if (rdata_buf == NULL) {log_printf("rdata_buf: not enough memory\n"); return -1;}

    taddr_buf = (uint32_t*) malloc(1024*16*4);
    if (taddr_buf == NULL) {log_printf("taddr_buf: not enough memory\n"); return -1;}

    memset (rdata_buf, 0, 1024*16*8);
    memset (taddr_buf, 0, 1024*16*4);

    uint32_t saddr_stat = MEM_BASE_CL + (ch << 12) + (0x11 << 3); // status register with busy bit
    uint64_t pos_status = (REG_BASE << 32) + saddr_stat;
    uint64_t pos = (REG_BASE << 32) + MEM_BASE_PT_D;

    // fill address buffer
    if (det_wr)
    {
        for (int i = 0; i < 1024*16; i++)
        {
            taddr_buf[i] = (i/1024)*CHIP_SIZE + (i & 0x3ff);
        }
    }
    else
    {
        for (int i = 0; i < 1024*16; i++)
        {
            taddr_buf[i] = (i/1024)*CHIP_SIZE;
        }
    }

    int bufs_to_write = 1024*16*4/FW_DATA_SIZE_B;

    for (int i = 0; i < bufs_to_write*2; i++) // not clear why *2 here, found experimentally
    {
        // fill address buffer in FW
        for (int j = 0; j < XFERS_FW_ADDR; j++)
            mwrite(fd,
                   taddr_buf + i*FW_ADDR_SIZE_B/4 + j*XFER_SIZE_B/4,
                   XFER_SIZE_B,
                   MEM_BASE_PT_A + j*XFER_SIZE_B);

        // send command
        value = 0x80; // set rd command bit
        mwrite(fd, &value, 8, saddr);
        value = 0; // remove
        mwrite(fd, &value, 8, saddr);

        do
        {
            // wait until not busy
            mread(fd, &value, 8, pos_status);
        } while ((value >> 21) & 1ULL);


        // read buffer
        for (int j = 0; j < XFERS_FW_DATA; j++)
            mread(fd,
                   rdata_buf + i*FW_DATA_SIZE_B/8 + j*XFER_SIZE_B/8,
                   XFER_SIZE_B,
                   pos + j*XFER_SIZE_B);

    }


    int64_t tot_words =  (int64_t)bufs_to_write * (int64_t)FW_DATA_SIZE_B/8;

    printf ("comparing %lx words\n", tot_words);

    bzero(err_bits, sizeof(err_bits));
//    int64_t one_chip = tot_words/8;
    int chip_err[16];
    bzero(chip_err, sizeof(chip_err));
    uint64_t chipn;
    uint32_t rd, rd_old, err_word;

    for (chipn = 0; chipn < 16; chipn++)
    {
        for (int64_t i = 64; i < 1024-64; i++)
        {
            rd_old = rd;
            rd = ((uint32_t*)rdata_buf)[chipn * 1024*2 + i]; // also *2 here is experimental
            if (i == 64) printf ("chip: %02ld ", chipn);
            if (i >= 64 && i <= 71) printf ("%05x ", rd);
            if (i == 71) printf ("\n");
            if (i > 64)
            {
                err_word = (~(rd ^ rd_old)) & 0x3ffff; // each bit must oscillate in test pattern
                err_bits[chipn] |= err_word;
            }

        }
    }


    free (rdata_buf);
    free (taddr_buf);

    return 0;

}

int rldram_detect_write_delays()
{
    uint32_t err_bits_vs_tap[31][16];
    uint32_t quad_err_bits_vs_tap[31][4];
    bzero(err_bits, sizeof(err_bits));
    bzero(err_bits_vs_tap, sizeof(err_bits_vs_tap));
    bzero(quad_err_bits_vs_tap, sizeof(quad_err_bits_vs_tap));

    uint64_t *wdata_buf;
    uint32_t *taddr_buf;
    core_link cl(device_d);
    int fd = device_d;
    uint64_t value;

    // module addresses
    uint32_t MEM_BASE_CL = 0x80000; //   bytes

    int ch = 45; // config register bank

    // form address {chamber[6], sel[2], addr[7], 3'b0}
    uint32_t saddr = MEM_BASE_CL + (ch << 12); // reset register has address 0
    uint32_t MEM_BASE_PT_D = 0x140000; // pt data buffer
    uint32_t MEM_BASE_PT_A = 0x142000; // pt address buffer

    // reserve buffers for tests
    // each 32-bit word contains one 18-bit word for RLDRAM
    wdata_buf = (uint64_t*) malloc(XFER_SIZE_B);
    if (wdata_buf == NULL) {log_printf("wdata_buf: not enough memory\n"); return -1;}

    taddr_buf = (uint32_t*) malloc(1024*16*4);
    if (taddr_buf == NULL) {log_printf("taddr_buf: not enough memory\n"); return -1;}

    memset (wdata_buf, 0, XFER_SIZE_B);
    memset (taddr_buf, 0, 1024*16*4);

    uint32_t saddr_stat = MEM_BASE_CL + (ch << 12) + (0x11 << 3); // status register with busy bit
    uint64_t pos_status = (REG_BASE << 32) + saddr_stat;

    // fill address buffer
    for (int i = 0; i < 1024*16; i++)
    {
        taddr_buf[i] = (i/1024)*CHIP_SIZE + ((i*2) & 0x3ff);
    }

    // fill data buffer
    uint64_t alt_pat = 0x55555555aaaaaaaaULL;
//    uint64_t alt_pat = 0xff00ff0000ff00ffULL;
//    uint64_t alt_pat = 0x5555555555555555ULL;
    for (int i = 0; i < XFER_SIZE_B/8; i++)
    {
        wdata_buf[i] = alt_pat;

    }

    int bufs_to_write = 1024*16*4/FW_DATA_SIZE_B;

    for (int i = 0; i < 31; i++) // delay tap loop
    {
        iddr_phase_inc(true, i);
        for (int k = 0; k < bufs_to_write*2; k++) // not clear why *2 here, found experimentally
        {
            // fill address buffer in FW
            for (int j = 0; j < XFERS_FW_ADDR; j++)
                mwrite(fd,
                       taddr_buf + k*FW_ADDR_SIZE_B/4 + j*XFER_SIZE_B/4,
                       XFER_SIZE_B,
                       MEM_BASE_PT_A + j*XFER_SIZE_B);


            // fill data buffer
            for (int j = 0; j < XFERS_FW_DATA; j++)
                mwrite(fd,
                       wdata_buf,
                       XFER_SIZE_B,
                       MEM_BASE_PT_D + j*XFER_SIZE_B);


            // send command
            value = 0x40; // set wr command bit
            mwrite(fd, &value, 8, saddr);
            value = 0; // remove
            mwrite(fd, &value, 8, saddr);

            do
            {
                // wait until not busy
                mread(fd, &value, 8, pos_status);
            } while ((value >> 21) & 1ULL);
        }
        // now read
        read_rldram_training(true);
        for (int j = 0; j < 16; j++) // chip loop
        {
            err_bits_vs_tap[i][j] = err_bits[j]; // store error bits for each chip
            quad_err_bits_vs_tap[i][j/4] |= err_bits[j]; // OR error bits for each quad
        }
    }

    FILE *chip_errors = fopen ("wr_chip_errors.dat", "w");
    FILE *quad_errors = fopen ("wr_quad_errors.dat", "w");
    char eln[20];
    // [quad][delay tap][bit]
    char ebits[4][31][18];

    for (int i = 0; i < 31; i++) // delay tap loop
    {
        fprintf (chip_errors, "%02d ", i);
        for (int j = 0; j < 16; j++) // chip loop
        {
            uint32_t eb = err_bits_vs_tap[i][j];
            for (int k = 0; k < 18; k++) // bit loop
            {
                eln[k] = ((eb >> (17-k)) & 1) + 0x30;
            }
            eln[18] = 0;
            fprintf (chip_errors, "%s ", eln);
        }

        fprintf(chip_errors, "\n");

        fprintf (quad_errors, "%02d ", i);
        for (int j = 0; j < 4; j++) // quad loop
        {
            uint32_t eb = quad_err_bits_vs_tap[i][j];
            for (int k = 0; k < 18; k++) // bit loop
            {
                eln[k] = ((eb >> (17-k)) & 1) + 0x30; // print MSB first, so index is reversed
                ebits[j][i][k] = ((eb >> k) & 1);
            }
            eln[18] = 0;
            fprintf (quad_errors, "%s ", eln);
        }

        fprintf(quad_errors, "\n");
    }

    // find optimal rx delays for each bit
    char ebit;

    int wcnt;
    for (int j = 0; j < 4; j++) // quad loop
    {
        printf("q: %d ", j);
        for (int k = 0; k < 18; k++) // bit loop
        {
            wcnt = 0;
            for (int i = 0; i < 31; i++) // delay tap loop
            {
                ebit = ebits[j][i][k];
                if (ebit == 0 && i < 30) wcnt++;
                else
                {
                    if (wcnt > 10) // found good window
                    {
                        best_rd_delay[j][k] = i - wcnt / 2; // put best delay in the middle of the window
                        break;
                    }
                    wcnt = 0;
                }

            }
            printf ("%02d ", best_rd_delay[j][k]);
        }
        printf ("\n");
    }

    set_dq_delays(true);
//    iddr_phase_inc(true, 30);
//    iddr_phase_inc(true, 7);

    // test now
//    for (int i = 0; i < 3; i++) // this is a f...ing mystery, works only on 3-rd write attempt, don't know why so far
    for (int k = 0; k < bufs_to_write*2; k++) // not clear why *2 here, found experimentally
    {
        // fill address buffer in FW
        for (int j = 0; j < XFERS_FW_ADDR; j++)
            mwrite(fd,
                   taddr_buf + k*FW_ADDR_SIZE_B/4 + j*XFER_SIZE_B/4,
                   XFER_SIZE_B,
                   MEM_BASE_PT_A + j*XFER_SIZE_B);


        // fill data buffer
        for (int j = 0; j < XFERS_FW_DATA; j++)
            mwrite(fd,
                   wdata_buf,
                   XFER_SIZE_B,
                   MEM_BASE_PT_D + j*XFER_SIZE_B);


        // send command
        value = 0x40; // set wr command bit
        mwrite(fd, &value, 8, saddr);
        value = 0; // remove
        mwrite(fd, &value, 8, saddr);

        do
        {
            // wait until not busy
            mread(fd, &value, 8, pos_status);
        } while ((value >> 21) & 1ULL);

    }
    // now read
    read_rldram_training(true);
    bzero(quad_err_bits_vs_tap, sizeof(quad_err_bits_vs_tap));
    for (int j = 0; j < 16; j++) // chip loop
    {
        quad_err_bits_vs_tap[0][j/4] |= err_bits[j]; // OR error bits for each quad
    }

    // print quad errors
    printf ("quad WR errors after delay adjustment:\n");
    for (int j = 0; j < 4; j++) // quad loop
    {
        uint32_t eb = quad_err_bits_vs_tap[0][j];
        for (int k = 0; k < 18; k++) // bit loop
        {
            eln[k] = ((eb >> (17-k)) & 1) + 0x30;
        }
        eln[18] = 0;
        printf ("%s ", eln);
    }

    printf("\n");

    fclose(chip_errors);
    fclose(quad_errors);

    return 0;
}

int rldram_detect_read_delays()
{

    uint32_t err_bits_vs_tap[31][16];
    uint32_t quad_err_bits_vs_tap[31][4];
    bzero(err_bits, sizeof(err_bits));
    bzero(err_bits_vs_tap, sizeof(err_bits_vs_tap));
    bzero(quad_err_bits_vs_tap, sizeof(quad_err_bits_vs_tap));

    iddr_phase_inc(true, 0); // reset write delays


    for (int i = 0; i < 31; i++) // delay tap loop
    {
        iddr_phase_inc(false, i);
        read_rldram_training(false);
        for (int j = 0; j < 16; j++) // chip loop
        {
            err_bits_vs_tap[i][j] = err_bits[j]; // store error bits for each chip
            quad_err_bits_vs_tap[i][j/4] |= err_bits[j]; // OR error bits for each quad
        }

        if (terminating)
        {
            terminating = false;
            break;
        }

        set_progress (i*100/31);
    }
    set_progress (100);

    FILE *chip_errors = fopen ("chip_errors.dat", "w");
    FILE *quad_errors = fopen ("quad_errors.dat", "w");
    char eln[20];
    // [quad][delay tap][bit]
    char ebits[4][31][18];

    for (int i = 0; i < 31; i++) // delay tap loop
    {
        fprintf (chip_errors, "%02d ", i);
        for (int j = 0; j < 16; j++) // chip loop
        {
            uint32_t eb = err_bits_vs_tap[i][j];
            for (int k = 0; k < 18; k++) // bit loop
            {
                eln[k] = ((eb >> (17-k)) & 1) + 0x30;
            }
            eln[18] = 0;
            fprintf (chip_errors, "%s ", eln);
        }

        fprintf(chip_errors, "\n");

        fprintf (quad_errors, "%02d ", i);
        for (int j = 0; j < 4; j++) // quad loop
        {
            uint32_t eb = quad_err_bits_vs_tap[i][j];
            for (int k = 0; k < 18; k++) // bit loop
            {
                eln[k] = ((eb >> (17-k)) & 1) + 0x30; // print MSB first, so index is reversed
                ebits[j][i][k] = ((eb >> k) & 1);
            }
            eln[18] = 0;
            fprintf (quad_errors, "%s ", eln);
        }

        fprintf(quad_errors, "\n");
    }

    // find optimal rx delays for each bit
    char ebit;

    int wcnt;
    for (int j = 0; j < 4; j++) // quad loop
    {
        printf("q: %d ", j);
        for (int k = 0; k < 18; k++) // bit loop
        {
            wcnt = 0;
            for (int i = 30; i >= 0; i--) // delay tap loop
            {
                ebit = ebits[j][i][k];
                if (ebit == 0 && i > 0) wcnt++;
                else
                {
                    if (wcnt > 8) // found good window
                    {
                        best_rd_delay[j][k] = i + wcnt / 2; // put best delay in the middle of the window
                        break; // finish as soon as first good window is found
                    }
                    wcnt = 0;
                }

            }
            printf ("%02d ", best_rd_delay[j][k]);
        }
        printf ("\n");
    }

    set_dq_delays(false); // set optimal read delays


    fclose(chip_errors);
    fclose(quad_errors);

    // final check
    // read one time
    read_rldram_training(false);
    bzero(quad_err_bits_vs_tap, sizeof(quad_err_bits_vs_tap));
    for (int j = 0; j < 16; j++) // chip loop
    {
        quad_err_bits_vs_tap[0][j/4] |= err_bits[j]; // OR error bits for each quad
    }

    // print quad errors
    printf ("quad RD errors after delay adjustment:\n");
    for (int j = 0; j < 4; j++) // quad loop
    {
        uint32_t eb = quad_err_bits_vs_tap[0][j];
        for (int k = 0; k < 18; k++) // bit loop
        {
            eln[k] = ((eb >> (17-k)) & 1) + 0x30;
        }
        eln[18] = 0;
        printf ("%s ", eln);
    }

    printf("\n");

    return 0;
}



int rep_count = 0;




int test_rldram(int iterations)
{

    set_progress (0);
    write_rldram();

    for (int i = 0; i < iterations; i++)
    {
        int err_count = read_rldram(true);
        if (err_count > 0)
        {
            log_printf ("iteration: %d error count: %d\n", i, err_count);
            break;
        }
        if (terminating)
        {
            terminating = false;
            log_printf("terminating\n");
            break;
        }
        set_progress((i+1)*100/iterations);
    }
    set_progress(100);
    return 0;
}


int write_mrs(uint32_t cs, uint32_t code)
{
    int fd = device_d;
    // module addresses
    uint32_t MEM_BASE_CL = 0x80000; //   bytes

    int ch = 45; // config register bank

    // form address {chamber[6], sel[2], addr[7], 3'b0}
    uint32_t saddr = MEM_BASE_CL + (ch << 12); // reset register has address 0
    uint32_t MEM_BASE_PT_D = 0x140000; // pt data buffer
    uint32_t MEM_BASE_PT_A = 0x142000; // pt address buffer

    // chip select mask into data buffer
    // bits 17:0 to bits 17:0
    // bits 31:18 to bits 45:32
    uint64_t value = cs;
    value = ((value << 14) & 0x3fff00000000ULL) | (cs & 0x3ffffULL);
//    log_printf("cs mask: %016llx\n", value);
    mwrite (fd, &value, 8, MEM_BASE_PT_D);

    // write command code into address buffer A=0
    value = code;
    mwrite (fd, &value, 8, MEM_BASE_PT_A);

    // send command
    value = 0x20; // set mrs command bit
    mwrite(fd, &value, 8, saddr);
    value = 0; // remove
    mwrite(fd, &value, 8, saddr);
    return 0;
}

// RLDRAM initialization procedure
int init_rldram(int fd, bool training)
{
//    uint32_t write_buf[1024];
    uint64_t value;

//    int fd = device_d;

    // module addresses
    uint32_t MEM_BASE_CL = 0x80000; //   bytes

    int ch = 45; // config register bank

    // form address {chamber[6], sel[2], addr[7], 3'b0}
    uint32_t saddr = MEM_BASE_CL + (ch << 12); // reset register has address 0
    uint32_t saddr_st = MEM_BASE_CL + (ch << 12) + (0x11 << 3); // status reg addr 11
    uint64_t pos_st = (REG_BASE << 32) + saddr_st;

    uint32_t saddr_ptconf = MEM_BASE_CL + (ch << 12) + (0x27 << 3); // pt config reg addr 27
//    uint64_t pos_ptconf = (REG_BASE << 32) + saddr_st;

    // ptlut configuration parameters
    uint64_t wr_lat  = 4;
    uint64_t rd_lat  = 15;// for version with RX FIFO
    uint64_t wr_term = wr_lat + 0x403; //0x408;//0x407;
    uint64_t rd_term = rd_lat + 0x3fe;//0x40a;
    uint64_t wr_shift = 1;
    uint64_t rd_shift = 0;
    uint64_t qr_sel = rd_lat - 5;
    uint64_t qw_sel = wr_lat - 2;
    uint64_t we_sel = rd_lat - 4; //8;

    uint64_t ptlut_config;
    ptlut_config = wr_term;
    ptlut_config |= rd_term  << 12;
    ptlut_config |= wr_lat   << (12+12);
    ptlut_config |= rd_lat   << (12+12+6);
    ptlut_config |= wr_shift << (12+12+6+6);
    ptlut_config |= rd_shift << (12+12+6+6+1);
    ptlut_config |= we_sel   << (12+12+6+6+1+1);
    ptlut_config |= qw_sel   << (12+12+6+6+1+1+5);
    ptlut_config |= qr_sel   << (12+12+6+6+1+1+5+5);
    // refresh is disabled now

    log_printf ("config reg: %016lx\n", ptlut_config);
    // write back
    mwrite(fd, &ptlut_config, 8, saddr_ptconf);

    value = 0x10; // set rldram reset bit
    mwrite(fd, &value, 8, saddr);

    usleep(10000);

    value = 0; // remove reset bit
    mwrite(fd, &value, 8, saddr);

    usleep(10000);

    log_printf ("RLDRAM reset\n");


    rd_training = false;
    uint64_t mrs[3] = {MR0, MR1, MR2};

    for (int i = 0; i < 3; i++)
    {
        write_mrs(0xffffffff, mrs[i]);
        usleep (10000);
    }

    if (training)
    {
        value = MR2_T2;
        uint32_t cs_mask = 0xffffffff;
        write_mrs(cs_mask, value);
        rd_training = true;
    }
    else
    {

//        value = MR2_T2;
//        uint32_t cs_mask = 0xffffffc3;
//        write_mrs(cs_mask, value);
    }

    value = ODT_OFF;
    uint32_t cs_mask = 0xffffffff;
    write_mrs(cs_mask, value);

    mread(fd, &value, 8, pos_st); // read delayctrl_lock status
    log_printf("delay_ctrl lock status: %x\n", (value >> 22) & 0xf);

    // reset IDELAY_CONTROL
    value = 0x2000; // IO and IDELAY_CONTROL reset
    mwrite(fd, &value, 8, saddr);

    usleep(10000);

    value = 0; // remove reset bit
    mwrite(fd, &value, 8, saddr);

    mread(fd, &value, 8, pos_st); // read delayctrl_lock status
    log_printf("delay_ctrl lock status: %x\n", (value >> 22) & 0xf);

    // enable refresh, program RX clock domain crossing polarity
    ptlut_config |= 3ULL   << (12+12+6+6+1+1+5+5+5);

    // program wait times after refresh and read cycles
    uint64_t wait_after_read = 1ull; //6ULL;
    uint64_t wait_after_refresh = 1ull; //6ULL;
    uint64_t core_req_mask = 1ULL; // ptlut requests enable mask
    ptlut_config |= wait_after_read    << (12+12+6+6+1+1+5+5+5+2);
    ptlut_config |= wait_after_refresh << (12+12+6+6+1+1+5+5+5+2+3);
    ptlut_config |= core_req_mask      << (12+12+6+6+1+1+5+5+5+2+3+3);

    log_printf ("config reg: %016lx\n", ptlut_config);
    // write
    mwrite(fd, &ptlut_config, 8, saddr_ptconf);

    return 0;
}


int rldram_detect_window()
{
    uint32_t err_bits_vs_tap[31][31][16];
    uint32_t quad_err_bits_vs_tap[31][31][4];
    uint32_t all_err_bits_vs_tap[31][31];
    bzero(err_bits, sizeof(err_bits));
    bzero(err_bits_vs_tap, sizeof(err_bits_vs_tap));
    bzero(quad_err_bits_vs_tap, sizeof(quad_err_bits_vs_tap));
    bzero(all_err_bits_vs_tap, sizeof(all_err_bits_vs_tap));

    uint64_t *wdata_buf;
    uint64_t *rdata_buf;
    uint32_t *taddr_buf;
    core_link cl(device_d);
    int fd = device_d;
    uint64_t value;

    // module addresses
    uint32_t MEM_BASE_CL = 0x80000; //   bytes

    int ch = 45; // config register bank

    // form address {chamber[6], sel[2], addr[7], 3'b0}
    uint32_t saddr = MEM_BASE_CL + (ch << 12); // reset register has address 0
    uint32_t MEM_BASE_PT_D = 0x140000; // pt data buffer
    uint32_t MEM_BASE_PT_A = 0x142000; // pt address buffer

    // reserve buffers for tests
    // each 32-bit word contains one 18-bit word for RLDRAM
    wdata_buf = (uint64_t*) malloc(XFER_SIZE_B);
    if (wdata_buf == NULL) {log_printf("wdata_buf: not enough memory\n"); return -1;}

    rdata_buf = (uint64_t*) malloc(1024*16*8);
    if (rdata_buf == NULL) {log_printf("rdata_buf: not enough memory\n"); return -1;}

    taddr_buf = (uint32_t*) malloc(1024*16*4);
    if (taddr_buf == NULL) {log_printf("taddr_buf: not enough memory\n"); return -1;}

    memset (wdata_buf, 0, XFER_SIZE_B);
    memset (taddr_buf, 0, 1024*16*4);

    uint32_t saddr_stat = MEM_BASE_CL + (ch << 12) + (0x11 << 3); // status register with busy bit
    uint64_t pos_status = (REG_BASE << 32) + saddr_stat;
    uint64_t pos = (REG_BASE << 32) + MEM_BASE_PT_D;

    // fill address buffer
    for (int i = 0; i < 1024*16; i++)
    {
        taddr_buf[i] = (i/1024)*CHIP_SIZE + ((i*2) & 0x3ff);
    }

//    uint64_t pat = 0ULL;
    for (int i = 0; i < XFER_SIZE_B/8; i++)
    {
        wdata_buf[i] = (1ULL << ((i*2) % 18)) | (1ULL << (((i*2+1) % 18) + 32));
//        wdata_buf[i] = (1 << ((i) % 18));
//        wdata_buf[i] = pat;
//        pat = ~pat;
    }

    int bufs_to_write = 1024*16*4/FW_DATA_SIZE_B;

    for (int wi = 0; wi < 31; wi++) // write delay tap loop
    {
        iddr_phase_inc(true, wi); // set write delays
        for (int ri = 0; ri < 31; ri++) // read delay tap loop
        {
            iddr_phase_inc(false, ri); // set read delays
            for (int k = 0; k < bufs_to_write*2; k++) // not clear why *2 here, found experimentally
            {
                // fill address buffer in FW
                for (int j = 0; j < XFERS_FW_ADDR; j++)
                    mwrite(fd,
                           taddr_buf + k*FW_ADDR_SIZE_B/4 + j*XFER_SIZE_B/4,
                           XFER_SIZE_B,
                           MEM_BASE_PT_A + j*XFER_SIZE_B);


                // fill data buffer
                for (int j = 0; j < XFERS_FW_DATA; j++)
                    mwrite(fd,
                           wdata_buf,
                           XFER_SIZE_B,
                           MEM_BASE_PT_D + j*XFER_SIZE_B);


                // send command
                value = 0x40; // set wr command bit
                mwrite(fd, &value, 8, saddr);
                value = 0; // remove
                mwrite(fd, &value, 8, saddr);

                do
                {
                    // wait until not busy
                    mread(fd, &value, 8, pos_status);
                } while ((value >> 21) & 1ULL);
            }

            // now read

            for (int k = 0; k < bufs_to_write*2; k++) // not clear why *2 here, found experimentally
            {
                // fill address buffer in FW
                for (int j = 0; j < XFERS_FW_ADDR; j++)
                    mwrite(fd,
                           taddr_buf + k*FW_ADDR_SIZE_B/4 + j*XFER_SIZE_B/4,
                           XFER_SIZE_B,
                           MEM_BASE_PT_A + j*XFER_SIZE_B);

                // send command
                value = 0x80; // set rd command bit
                mwrite(fd, &value, 8, saddr);
                value = 0; // remove
                mwrite(fd, &value, 8, saddr);

                do
                {
                    // wait until not busy
                    mread(fd, &value, 8, pos_status);
                } while ((value >> 21) & 1ULL);


                // read buffer
                for (int j = 0; j < XFERS_FW_DATA; j++)
                    mread(fd,
                           rdata_buf + k*FW_DATA_SIZE_B/8 + j*XFER_SIZE_B/8,
                           XFER_SIZE_B,
                           pos + j*XFER_SIZE_B);

            }


//            int64_t tot_words =  (int64_t)bufs_to_write * (int64_t)FW_DATA_SIZE_B/8;

//            printf ("comparing %lx words\n", tot_words);

            bzero(err_bits, sizeof(err_bits));
        //    int64_t one_chip = tot_words/8;
            int chip_err[16];
            bzero(chip_err, sizeof(chip_err));
            uint64_t chipn;
            uint32_t rd, rd_old, err_word;
            int bit_cnt[18];
            bool bit_check_start[18];

            for (chipn = 0; chipn < 16; chipn++)
            {
                bzero(bit_check_start, sizeof(bit_check_start));
                err_word = 0;
                for (int64_t i = 128; i < 1024-128; i++)
                {
                    rd_old = rd;
                    rd = ((uint32_t*)rdata_buf)[chipn * 1024*2 + i]; // also *2 here is experimental
                    if (i == 64) printf ("chip: %02ld ", chipn);
//                    if (i >= 64 && i <= 164) printf ("%05x\n ", rd);
//                    if (i >= 64 && i <= 164) {for (int y = 0; y < 18; y++) printf ("%d", (rd >> y)&1); printf ("\n");}
//                    if (i == 71) printf ("\n");

                    // each bit must appear every 18 words
                    for (int bi = 0; bi < 18; bi++) // bit loop
                    {
                        int sb = (rd >> bi) & 1; // selected bit
                        if (sb == 1)
                        {
//                            if (bi == 2) printf ("bit_cnt: %d\n", bit_cnt[bi]);
                            if (bit_cnt[bi] != 18 && bit_cnt[bi] != 4 && bit_check_start[bi])
                            {
                                err_word |= (1 << bi);
                            }
                            bit_cnt[bi] = 0;
                            bit_check_start[bi] = true; // start checking when the first =1 has been found
                        }
                        bit_cnt[bi]++;
                    }
                }
                for (int bi = 0; bi < 18; bi++)
                {
                    // if bits=1 not found, set error
                    if (!bit_check_start[bi]) err_word |= (1 << bi);
                }
                err_bits[chipn] |= err_word;
            }


            for (int j = 0; j < 16; j++) // chip loop
            {
                err_bits_vs_tap[wi][ri][j] = err_bits[j]; // store error bits for each chip
                quad_err_bits_vs_tap[wi][ri][j/4] |= err_bits[j]; // OR error bits for each quad
                all_err_bits_vs_tap[wi][ri] |= err_bits[j]; // OR error bits for all chips
            }
        }
        set_progress(wi*100./31);
    }
    set_progress(100);


    FILE *qwin[4];
    qwin[0] = fopen("qwin0.dat", "w");
    qwin[1] = fopen("qwin1.dat", "w");
    qwin[2] = fopen("qwin2.dat", "w");
    qwin[3] = fopen("qwin3.dat", "w");
    for (int qi = 0; qi < 4; qi++)
    {
        for (int bi = 0; bi < 18; bi++)
        {
            fprintf (qwin[qi], "quad: %d bit: %d\n", qi, bi);
            for (int wi = 0; wi < 31; wi++) // write delay tap loop
            {
                for (int ri = 0; ri < 31; ri++) // read delay tap loop
                {
                    int bv = ((quad_err_bits_vs_tap[wi][ri][qi] >> bi) & 1);
                    fprintf (qwin[qi], "%d ", bv);
                }
                fprintf (qwin[qi], "\n");
            }
        }
    }

    fclose (qwin[0]);
    fclose (qwin[1]);
    fclose (qwin[2]);
    fclose (qwin[3]);

    FILE *cwin[16];
    char cfname[100];
    for (int ci = 0; ci < 16; ci++)
    {
        sprintf(cfname, "cwin%02d.dat", ci);
        cwin[ci] = fopen(cfname, "w");
        for (int bi = 0; bi < 18; bi++)
        {
            fprintf (cwin[ci], "chip: %d bit: %d\n", ci, bi);
            for (int wi = 0; wi < 31; wi++) // write delay tap loop
            {
                for (int ri = 0; ri < 31; ri++) // read delay tap loop
                {
                    int bv = ((err_bits_vs_tap[wi][ri][ci] >> bi) & 1);
                    fprintf (cwin[ci], "%d ", bv);
                }
                fprintf (cwin[ci], "\n");
            }
        }
        fclose (cwin[ci]);
    }



    return 0;

}


