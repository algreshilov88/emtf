#ifndef CORE_LINK_H
#define CORE_LINK_H

#include <stdint.h>
#include <unistd.h>
#include "sp12_macros.h"


// PCIe registers
// core link module addresses
#define MEM_BASE 0x80000 //
#define REG_BASE 0x40ULL // 0x40ULL
#define CL_REG (REG_BASE + 0x10)
#define CL_RST (REG_BASE + 0x14)

// markers
#define LAST     0x80000000 // last word marker (control module)
#define RDRQ     0x02000000 // read request marker (core)
#define DRP      0x01000000 // drp request
#define DRPA     0x00800000 // drp address

// components
#define DEN_PRBS 0x00320000 // den decoder for PRBS and loopback params
#define DEN_GTH(n) ((0x30 + n) << 16) // den decoder for GTH number n quad
#define DEN_GTX(n) (n << 16) // den decoder for GTX number n

#define GTH_CNT 2 // how many quads active now


class core_link
{
public:
    int fd;
    core_link(int device_d){fd = device_d;}
    int write_core_config (uint32_t *config_regs, int reg_count);
    int read_core_status  (uint32_t *status_regs, int reg_count);

};

#endif // CORE_LINK_H
