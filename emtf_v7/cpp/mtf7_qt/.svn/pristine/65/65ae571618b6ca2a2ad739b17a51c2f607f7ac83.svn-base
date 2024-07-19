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
#include "core_link.h"
#include "CAENVMElib.h"


using namespace std;

int prbs_errors_main(string command)
{


    if (command.compare("gth") == 0)
    {
    }
    return 0;
}

#ifdef BLABLA
int SP04_prbs_check()
{
    int32_t BHandle, value;

    if( CAENVME_Init(/*VMEBoard*/cvV2718, /*Link*/0, /*Device*/0, &BHandle) != cvSuccess )
    {
        log_printf("\n\n Error opening VME controller driver\n");
    }

    int sa = 9; // SP04 slot
    int csr_lnk = 0x40; // prbs enable register address
    int act_lcr = 2; // link counter reset address
    for (int ca = 1; ca <= 16; ca <<= 1) // chip loop
    {
        for (int ma = 1; ma <= 3; ma++) // muon loop
        {
            int addr = (sa << 19) | (ca << 12) | (ma << 9) | (csr_lnk << 2); // full address
            check_ret (CAENVME_ReadCycle(BHandle, addr, &value, cvA24_U_DATA, cvD16));
            value &= 0xffff;
            int prbs_err_count = (value >> 11) & 31;
            int prbs_detected = (value >> 9) & 1;
            log_printf("chip: %02x muon: %d val: %04x prbs detected: %d prbs error count: %d\n",
                       ca, ma, value, prbs_detected, prbs_err_count);

            value = 0x55; // enable PRBS detection
            check_ret (CAENVME_WriteCycle(BHandle, addr, &value, cvA24_U_DATA, cvD16));

            addr = (sa << 19) | (ca << 12) | (ma << 9) | (act_lcr << 2); // full address
            value = 8; // reset PRBS error counter bit
            check_ret (CAENVME_WriteCycle(BHandle, addr, &value, cvA24_U_DATA, cvD16));


        }
    }

    CAENVME_End(BHandle);
    return 0;

}
#endif
