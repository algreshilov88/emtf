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


using namespace std;
/*
int gtx_bitrate(string command, uint64_t rate)
{

    uint32_t tx_m, tx_n1, tx_n2, tx_d, tx_pll, tx_rate, tx_dclk;
    uint32_t rx_m, rx_n1, rx_n2, rx_d, rx_pll, rx_rate, rx_dclk;
    uint32_t refclk = 160; // MHz
    uint32_t reg_1b;
    uint32_t reg_1c;
    uint32_t reg_1f;
    uint32_t reg_20;

    core_link cl(device_d);

    if (command.compare("read") == 0)
    {

        log_printf("GTX bitrate\n");

        reg_1b = cl.read(0x1b, DEN_GTX(0));
        reg_1c = cl.read(0x1c, DEN_GTX(0));
        reg_1f = cl.read(0x1f, DEN_GTX(0));
        reg_20 = cl.read(0x20, DEN_GTX(0));

        tx_m  = ((reg_20 >> 1)  & 0x1f) == 0 ? 2 : 1;
        tx_n1 = ((reg_1f >> 6)  & 1) + 4;
        tx_n2 = ((reg_1f >> 1)  & 0x1f) + 2;
        tx_d  = 1 << ((reg_1f >> 14) & 3);
        tx_pll = refclk * tx_n1 *tx_n2 / tx_m;
        tx_rate = tx_pll * 2 / tx_d;
        tx_dclk = tx_rate / 20;

        rx_m  = ((reg_1c >> 1)  & 0x1f) == 0 ? 2 : 1;
        rx_n1 = ((reg_1b >> 6)  & 1) + 4;
        rx_n2 = ((reg_1b >> 1)  & 0x1f) + 2;
        rx_d  = 1 << ((reg_1b >> 14) & 3);
        rx_pll = refclk * rx_n1 *rx_n2 / rx_m;
        rx_rate = rx_pll * 2 / rx_d;
        rx_dclk = rx_rate / 20;


        log_printf("1b: %04x 1c: %04x 1f: %04x 20: %04x\n", reg_1b, reg_1c, reg_1f, reg_20);
        log_printf("tx: M: %d  N1: %d  N2: %d  D: %d  PLL: %d  Rate: %d  Data clk: %d\n",
                   tx_m, tx_n1, tx_n2, tx_d, tx_pll, tx_rate, tx_dclk);
        log_printf("rx: M: %d  N1: %d  N2: %d  D: %d  PLL: %d  Rate: %d  Data clk: %d\n",
                   rx_m, rx_n1, rx_n2, rx_d, rx_pll, rx_rate, rx_dclk);
    }
    else if (command.compare("set") == 0)
    {
        tx_m  = rx_m  = 0x10;
        tx_n1 = rx_n1 = 1;
        tx_n2 = rx_n2 = 1; // default
        tx_d  = rx_d  = 0; // default
        switch(rate)
        {
        case 0: // 6.4
            tx_n2 = rx_n2 = 2;
            tx_d  = rx_d  = 0;
            break;
        case 1: // 4.8
            tx_n2 = rx_n2 = 1;
            tx_d  = rx_d  = 0;
            break;
        case 2: // 3.2
            tx_n2 = rx_n2 = 2;
            tx_d  = rx_d  = 1;
            break;
        case 3: // 2.4
            tx_n2 = rx_n2 = 1;
            tx_d  = rx_d  = 1;
            break;
        case 4: // 1.6
            tx_n2 = rx_n2 = 0;
            tx_d  = rx_d  = 1;
            break;
        }

        // read current registers
        reg_1b = cl.read(0x1b, DEN_GTX(0));
        reg_1c = cl.read(0x1c, DEN_GTX(0));
        reg_1f = cl.read(0x1f, DEN_GTX(0));
        reg_20 = cl.read(0x20, DEN_GTX(0));

        // modify fields
        reg_1b &= 0x3f81;
        reg_1b |= (tx_n1 << 6) | (tx_n2 << 1) | (tx_d << 14);
        reg_1c &= 0xffc1;
        reg_1c |= (tx_m << 1);

        reg_1f &= 0x3f81;
        reg_1f |= (tx_n1 << 6) | (tx_n2 << 1) | (tx_d << 14);
        reg_20 &= 0xffc1;
        reg_20 |= (tx_m << 1);

        // write back into all GTXs
        for (int i = 0; i < 48; i++)
        {
            cl.write(0x1b, DEN_GTX(i), reg_1b);
            cl.write(0x1c, DEN_GTX(i), reg_1c);
            cl.write(0x1f, DEN_GTX(i), reg_1f);
            cl.write(0x20, DEN_GTX(i), reg_20);
        }

        gtx_bitrate("read", 0); // read and print
    }

    return 0;
}
*/
