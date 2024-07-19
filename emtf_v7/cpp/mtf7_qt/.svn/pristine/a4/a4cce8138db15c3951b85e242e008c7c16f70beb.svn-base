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
#include "extralong.h"

#define seg_ch 2
#define max_ev 512
using namespace std;
void read_dat_file(std::string filename);

extern uint8_t quality   [max_ev+10][6][9][seg_ch];
extern uint8_t wiregroup [max_ev+10][6][9][seg_ch];
extern uint8_t hstrip    [max_ev+10][6][9][seg_ch];
extern uint8_t pattern   [max_ev+10][6][9][seg_ch];

extern int daq_mpc_data_into_file(string mpc_data_fn, int iterations, bool only_read);

// inject memory arrays
// these arrays mirror the inject memory in FPGA (64- and 32-stub)
uint64_t inject_64[16384], inject_32[16384];

// spy memory
uint32_t spy_mem[32768];

int core_link_phase_inc(int target);

int core_logic_test()
{
    log_printf ("set DAQ delay to 54 before running this test\n");

    int fd = device_d;
    uint32_t MEM_BASE = 0x80000; // 0xc0000  bytes
    uint32_t MEM_BASE_64 = 0xc0000; // base address of 64-stub memory
    uint32_t MEM_BASE_32 = 0xe0000; // base address of 32-stub memory
    uint64_t REG_BASE = 0x40ULL; // 0x40ULL // bytes
    uint32_t DATA_SIZE   = 0x800; //one transfer size

    uint32_t MEM_SIZE_64 = 0x20000; //size of inject_64 memory
    uint32_t N_WRITES_64 = (MEM_SIZE_64 / DATA_SIZE); // how many transfers for entire buffer

    uint32_t MEM_SIZE_32 = 0x20000; //size of inject_32 memory
    uint32_t N_WRITES_32 = (MEM_SIZE_32 / DATA_SIZE); // how many transfers for entire buffer

    int ch = REG_BANK_CH; // config register bank

    uint32_t saddr = MEM_BASE + (ch << 12) + (0x11 << 3); // spy config register has address 0x11

    // read register. Size is in bytes
    off_t pos = (REG_BASE << 32) + saddr;
    uint64_t value;
    mread(fd, &value, 8, pos);

    log_printf ("spy config register: %02llx\n", value);

    value |= (1 << 20); // set inject enable bit
    mwrite(fd, &value, 8, saddr);

    // read register. Size is in bytes
    pos = (REG_BASE << 32) + saddr;
    mread(fd, &value, 8, pos);

    log_printf ("spy config register: %02llx\n", value);

    // read input file
    read_dat_file("data_n.dat");
//    read_dat_file("large_dphi.dat");

    // fill inject memory arrays
    // stub format: {q[4], pattern[4], 1'b0, wiregroup[7], halfstrip[8]}, total 24 bits
    // chamber format: {8'b0, stub[1], 8'b0, stub[0]}, total 64 bits (48 bits used)

    bzero(inject_64, sizeof(inject_64));
    bzero(inject_32, sizeof(inject_32));
    int ind64, ind32;
    for (int ev = 0; ev < max_ev; ev++) // event loop
    {
        for (int st = 0; st < 6; st++) // station loop
        {
            for (int ch = 0; ch < 9; ch++) // chamber loop
            {
                uint64_t stub[2];
                for (int seg = 0; seg < 2; seg++) // segment loop
                {
                    // form one stub data
                    stub[seg] = hstrip[ev][st][ch][seg];
                    stub[seg] |= (wiregroup[ev][st][ch][seg] << 8);
                    stub[seg] |= (pattern[ev][st][ch][seg] << 16);
                    stub[seg] |= (quality[ev][st][ch][seg] << 20);
                }
                // one chamber data word
                uint64_t chamber = stub[0];
                chamber |= (stub[1] << 32);

                // place chamber data into injection memory
                if ((st*9 + ch) < 32)
                {
                    ind64 = ev*32 + st*9 + ch;
                    if (ind64 < 16384)
                        inject_64[ind64] = chamber;
                }
                else
                {
                    if (st == 5) log_printf ("station 5 word: %016llx index: %08x\n", chamber, ind32);
                    ind32 = ev*32 + st*9 + ch - 32;
                    if (ind32 < 16384)
                        inject_32[ind32] = chamber;
                }
            }
        }
    }

    log_printf ("memory indexes: 64: %d, 32: %d\n", ind64, ind32);

    bzero(spy_mem, sizeof(spy_mem));

    // write injection memories into FPGA

    // write 64-stub memory
    for (uint32_t j = 0; j < N_WRITES_64; j++)
    {
        mwrite(fd, &(inject_64[j * DATA_SIZE/8]), DATA_SIZE, MEM_BASE_64 + j * DATA_SIZE);
    }

    // write 32-stub memory
    for (uint32_t j = 0; j < N_WRITES_32; j++)
    {
        mwrite(fd, &(inject_32[j * DATA_SIZE/8]), DATA_SIZE, MEM_BASE_32 + j * DATA_SIZE);
    }

//    core_link_phase_inc(0); //  this actually injects data into logic

    // inject data into logic

    // form address {chamber[6], sel[2], addr[7], 3'b0}
    saddr = MEM_BASE + (ch << 12); // reset register has address 0

    // read register. Size is in bytes
    pos = (REG_BASE << 32) + saddr;
    mread(fd, &value, 8, pos);

    log_printf ("reset register: %02llx\n", value);

    value = 4; // set spy memory reset
    mwrite(fd, &value, 8, saddr);

    value = 2; // set inject bit, remove spy memory reset
    mwrite(fd, &value, 8, saddr);

    // read register. Size is in bytes
    pos = (REG_BASE << 32) + saddr;
    mread(fd, &value, 8, pos);

    log_printf ("reset register: %02llx\n", value);

    value = 0; // remove reset bit
    mwrite(fd, &value, 8, saddr);

    // read register. Size is in bytes
    pos = (REG_BASE << 32) + saddr;
    mread(fd, &value, 8, pos);

    log_printf ("reset register: %02llx\n", value);



    // read spy memory back

    daq_mpc_data_into_file("best_tracks.dat", 1, true);

    log_printf("done\n");

    return 0;
}
