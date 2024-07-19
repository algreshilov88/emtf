#include <iostream>
#include <iomanip>
#include <string.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/time.h>
#include <stdint.h>
#include <stdio.h>
#include <time.h>
#include <bitset>
#include <qthread.h>
#include "sp12_macros.h"

#define DATA_SIZE 0x1000
#define N_WRITES       400000
#define N_WRITES_LONG  40000

// PCIe register addresses
#define FLASH_WADDR (0x20 + 0x4)
#define FLASH_RADDR (0x20 + 0x4)
#define FLASH_DATA (0x20 + 0x8)
#define FLASH_RST  (0x20 + 0x0)
#define CONFIG_CONTROL  (0x20 + 0xc)
#define CORE_FW_START  (0x20 + 0x10)
#define PT_FW_START  (0x20 + 0x14)
#define SM_STATES (0x20 + 0x18) // RO
#define ICAP (0x20 + 0x18) // WO

#define BLK_SIZE 0x10000 // block size in 16-bit words
#define BLK_SIZE_B (BLK_SIZE * 2) // block size in bytes
#define BUF_SIZE 512 // programming buffer inside flash
#define NBLOCKS 32 //1024
#define BLK_RESERVED 25 // count of blocks reserved for control fw at low addresses

// FLASH command codes
#define CMD_PROGW     0x40 // program single word
#define CMD_PROGBUF   0xe8 // buffered programming
#define CMD_BLKERASE  0x20 // erase block
#define CMD_BLANKCHK  0xBC // blank check
#define CMD_BLKUNLOCK 0x60 // unlock block
#define CMD_CLRSTATUS 0x50 // clear status register
#define CMD_CNF       0xd0 // confirmation
#define CMD_READARRAY 0xff // normal read memory mode

#define FLASH_TOUT 100000 // timeout (0.1 S)

using namespace std;

class reverser16
{
public:
    // service class for fast bit order reversal in FPGA config data
    uint16_t* lut;
    std::bitset<16> a, b;
    reverser16()
    {
        // reserve memory for LUT
        lut = (uint16_t*) malloc (0x10000*2);
        if (lut == NULL) {log_printf ("Cannot allocate bit reversing LUT\n"); return;}

        // fill LUT
        for (int i = 0; i < 0x10000; i++)
        {
            a = i;
            for (int j = 0; j < 16; j++) b[j] = a[15-j];
            lut[i] = (uint32_t)b.to_ulong();
        }
        log_printf("bit reverser created\n");
    }

    uint16_t reverse(uint16_t in)
    {
        return lut[in];
    }
};

reverser16 r16;

class flash
{

public:
    int fd;
    flash()
    {
    }

    ~flash()
    {
    }

    void set_fd(int val)
    {
        fd = val;
    }

    void reset_flash()
    {
        uint32_t val;
        val = 0;
        mwrite(fd, &val, 4, FLASH_RST); // flash reset
        usleep(10000);
    }

    void command_1w(uint32_t addr, uint32_t data1)
    {
        mwrite(fd, &addr, 4, FLASH_WADDR); // address
        mwrite(fd, &data1, 4, FLASH_DATA); // word 1
    }

    void command_2w(uint32_t addr, uint32_t data1, uint32_t data2)
    {
        mwrite(fd, &addr, 4, FLASH_WADDR); // address
        mwrite(fd, &data1, 4, FLASH_DATA); // word 1
        mwrite(fd, &data2, 4, FLASH_DATA); // word 2
    }

    uint32_t read_word(uint32_t addr)
    {
        uint32_t val;
        mwrite(fd, &addr, 4, FLASH_RADDR); // address
        mread(fd, &val, 4, FLASH_DATA);
        return val;
    }
    void read_block(uint32_t addr, uint16_t* data, int lng)
    {
        uint32_t val;
        mwrite(fd, &addr, 4, FLASH_RADDR); // address
        for (int i = 0; i < lng; i++)
        {
            mread(fd, &val, 4, FLASH_DATA);
            data[i] = (uint16_t)val;
        }
    }

    uint32_t read_status()
    {
        return read_word(0);
    }

    uint32_t flow_2w(uint32_t addr, uint32_t data1, uint32_t data2)
    {
        uint32_t val;
	int j;
	struct timespec timeOut,remains;

	timeOut.tv_sec = 0;
	timeOut.tv_nsec = 1000; // 1 uS

        command_2w(addr, data1, data2);
        // check status
        for (j = 0; j < FLASH_TOUT; j++)
        {
            val = read_status();
	    nanosleep(&timeOut, &remains);
            if (((val >> 7) & 1) == 1) break;
        }
        if (j == FLASH_TOUT)
        {
            log_printf("Flow_2w  timeout. Status: %x opcode: %x\n", val, data1);
            return val; // flash does not become ready for some reason
        }
        if (!(val == 0x80 || (val == 0xa0 && data1 == CMD_BLANKCHK))) // status a0 during erase op is OK
        {
            log_printf("FLASH error status: %x opcode: %x\n", val, data1);
        }
        return val;
    }

    uint32_t program_buffer(uint32_t addr, uint16_t* data)
    {
        uint32_t val;
        int i = 0, j;
        // implements buffered programming algorithm
        for (i = 0; i < FLASH_TOUT; i++)
        {
            command_1w(addr, CMD_PROGBUF); // program buffered command
            val = read_status();
            if ((val & 0x80) == 0x80) break;
        }
        if (i == FLASH_TOUT)
        {
            log_printf("Buffer program init: timeout. Status: %x\n", val);
            return val; // flash does not become ready for some reason
        }
        if (val != 0x80)
        {
            log_printf("Buffer program init: FLASH error status: %x\n", val);
        }

        command_1w(addr, BUF_SIZE-1); // word count is buffer length - 1

        // now write data
        for (i = 0; i < BUF_SIZE; i++)
        {
            command_1w(addr+i, data[i]);
        }

        command_1w(addr, CMD_CNF); // confirm code

        for (j = 0; j < FLASH_TOUT; j++)
        {
            val = read_status();
            if (((val >> 7) & 1) == 1) break;
        }
        if (j == FLASH_TOUT)
        {
            log_printf("Buffer program finish: timeout. Status: %x\n", val);
            return val; // flash does not become ready for some reason
        }
        if (val != 0x80)
        {
            log_printf("Buffer program finish: FLASH error status: %x\n", val);
        }
        return val;
    }

    uint32_t erase_block(uint32_t address)
    {
        uint32_t val;
        command_2w(address, CMD_BLKUNLOCK, CMD_CNF); // unlock block
        command_1w(address, CMD_CLRSTATUS);

        val = flow_2w(address, CMD_BLANKCHK, CMD_CNF); // blank check
	if (!(val == 0x80 || val == 0xa0)) // status a0 during erase op is OK
	  {
	    log_printf("FLASH error during blank check, exiting\n");
	    return val;
	  }

        command_1w(address, CMD_CLRSTATUS);

        if (((val >> 5) & 1) == 1) // not blank, need to erase
        {

            flow_2w(address, CMD_BLKERASE, CMD_CNF); // erase block
            command_1w(address, CMD_CLRSTATUS);

            val = flow_2w(address, CMD_BLANKCHK, CMD_CNF); // blank check
            command_1w(address, CMD_CLRSTATUS);

            if (((val >> 5) & 1) == 1) // still not blank, problem
            {
                log_printf("cannot erase block at address: %x\n", address);
                return val;
            }
        }
        return val;
    }

    uint32_t program_block(uint32_t address, uint16_t* data)
    {

        for (int i = 0; i < BLK_SIZE / BUF_SIZE; i++)
        {
            program_buffer(address + i*BUF_SIZE, &data[i*BUF_SIZE]);
            command_1w(address, CMD_CLRSTATUS);
            command_1w(address, CMD_READARRAY);
        }

        return BLK_SIZE;
    }


};

class flash_erase_thread_c : public QThread
{
public:
    flash *fp;
    uint32_t nblocks, start_block;
protected:
    void run()
    {
        log_printf ("flash erase thread starts, fd: %d\n", fp->fd);
        for (uint32_t i = 0; i < nblocks; i++)
        {
            set_progress(i*100/nblocks);
            uint32_t val = fp->erase_block ((start_block + i) * BLK_SIZE);
            if (((val >> 5) & 1) == 1) break; // error erasing block
        }
        set_progress (100);
        log_printf ("flash erase thread exits, fd: %d\n", fp->fd);

    }
};

flash_erase_thread_c fet[13];

class flash_verify_thread_c : public QThread
{
public:
    flash *fp;
    uint32_t nblocks, start_block;
    uint16_t* buffer = NULL;
protected:
    void run()
    {
        uint16_t val;
        log_printf ("flash verify thread starts, fd: %d\n", fp->fd);

        uint16_t* rbuffer = (uint16_t*) malloc (BLK_SIZE_B);
        if (rbuffer == NULL) {log_printf ("Memory error, fd: %d\n", fp->fd); return;}


        //FILE* vout = fopen("flash_image.dat", "wb");
        int err_cnt = 0;
        for (uint32_t j = 0; j < nblocks; j++)
        {
            fp->read_block((start_block + j) * BLK_SIZE, rbuffer, BLK_SIZE);
            //fwrite(rbuffer, 1, BLK_SIZE_B, vout);
            set_progress(j*100/nblocks);

            for (uint32_t k = 0; k < BLK_SIZE; k++)
            {

                val = rbuffer[k];
                if (val != buffer[j*BLK_SIZE+k])
                {
                    err_cnt++;
                    if (err_cnt > 100) break;
                    log_printf ("mismatch: k: %08x w: %04x r: %04x\n",
                                j*BLK_SIZE+k, buffer[j*BLK_SIZE+k], val);
                }
            }
            if (err_cnt > 100) break;
        }

        //fclose (vout);
        set_progress (100);
        log_printf ("flash verify thread exits, fd: %d\n", fp->fd);
        free(rbuffer);

    }
};

flash_verify_thread_c fvt[13];

class flash_write_thread_c : public QThread
{
public:
    flash *fp;
    uint32_t nblocks, start_block;
    uint16_t* buffer = NULL;
protected:
    void run()
    {
        log_printf ("flash write thread starts, fd: %d\n", fp->fd);
        for (uint32_t j = 0; j < nblocks; j++)
        {
            set_progress(j*100/nblocks);
            fp->program_block ((start_block + j) * BLK_SIZE, &buffer[j * BLK_SIZE]);
        }
        set_progress (100);
        log_printf ("flash write thread exits, fd: %d\n", fp->fd);

    }
};

flash_write_thread_c fwt[13];

int flash_main(string command, string fname_core, string fname_control, bool do_control)
{

    uint32_t val;

    flash f[13]; // make flash objects for all boards in the system

    for (int i = 0; i < 13; i++)
    {
        f[i].set_fd(devices_d[i]);
    }

    log_printf("flash operation: %s, core file: %s, control file: %s do control: %d\n",
               command.c_str(), fname_core.c_str(), fname_control.c_str(), do_control);

    if ((command.compare("reboot") == 0) && (!do_control)) // core config
    {

        // start config on each FPGA first
        for (int i = 0; i < 13; i++)
        {
            if (f[i].fd >= 0)
            {
                log_printf("device index: %d\n", i);
                mread(f[i].fd, &val, 4, CORE_FW_START); // read firmware start address before reboot
                log_printf("core    f/w start: %x (hardcoded)\n", val);
                mread(f[i].fd, &val, 4, PT_FW_START); // read firmware start address before reboot
                log_printf("control f/w start: %x (hardcoded)\n", val);

                val = 1;
                mwrite(f[i].fd, &val, 4, CONFIG_CONTROL); // configuration start
            }
        }

        // now check status
        for (int i = 0; i < 13; i++)
        {
            if (f[i].fd >= 0)
            {
                log_printf("device index: %d\n", i);
                for (int j = 0; j < 20; j++)
                {
                    mread(f[i].fd, &val, 4, CONFIG_CONTROL); // read configuration status
                    //            log_printf("status: %x\n", val);

                    bool core_done = (val >>2)&1;
                    log_printf("core: OK: %d d: %d i: %d e: %d   ",
                               (val >>3)&1, (val >>2)&1, (val >>1)&1, val&1
                               );
                    mread(f[i].fd, &val, 4, SM_STATES); // read state machine states
                    log_printf("sm state: core: %d\n", val & 0xf);
                    if (core_done) break; // core done is up
                    usleep(200000);
                }
            }
        }
        log_printf("done\n");
        return 0;
    }
    if ((command.compare("reboot") == 0) && (do_control)) // control config
    {

        for (int i = 0; i < 13; i++)
        {
            if (f[i].fd >= 0)
            {
                mread(f[i].fd, &val, 4, CORE_FW_START); // read firmware start address before reboot
                log_printf("core f/w start: %x\n", val);
                mread(f[i].fd, &val, 4, PT_FW_START); // read firmware start address before reboot
                log_printf("pt   f/w start: %x\n", val);

                // sequence of words for IPROG (Internal PROGram) command
                // list of commands is here:
                // http://www.xilinx.com/support/documentation/user_guides/ug470_7Series_Config.pdf
                // page: 106
                uint32_t iprog[11] =
                {
                    0xFFFFFFFFUL, // Dummy Word
                    0x5599aa66UL, // Sync Word
                    0x04000000UL, // Type 1 NO OP
                    0x04000000UL, // Type 1 NO OP
                    0x0c400080UL, // Type 1 Write 1 Words to WBSTAR
                    0x00000000UL, // Warm Boot Start Address (Load the Desired Address)
                    0x04000000UL, // Type 1 NO OP
                    0x04000000UL, // Type 1 NO OP
                    0x0c000180UL, // Type 1 Write 1 Words to CMD
                    0x000000F0UL, // IPROG Command
                    0x04000000UL // Type 1 NO OP
                };

                for (int j = 0; j < 11; j++)
                {
                    val = iprog[j];
                    mwrite(f[i].fd, &val, 4, ICAP); // write icap register
                }
                // board should cease to exist at this time. Reboot needed.
            }
        }

        log_printf("Reboot the PC now\n");
        return 0;
    }

    if ((command.compare("reset") == 0) && (do_control)) // control unconfig
    {

        // sequence of words to unprogram control FPGA
        // list of commands is here:
        // http://www.xilinx.com/support/documentation/user_guides/ug470_7Series_Config.pdf
        // page: 106
        uint32_t iprog[21] =
        {
            0xFFFFFFFFUL, // Dummy Word
            0x5599aa66UL, // Sync Word
            0x04000000UL, // Type 1 NO OP
            0x04000000UL, // Type 1 NO OP
            0x0c400080UL, // Type 1 Write 1 Words to WBSTAR
            0x00000000UL, // Warm Boot Start Address (Load the Desired Address)
            0x04000000UL, // Type 1 NO OP
            0x04000000UL, // Type 1 NO OP
            0x0c000180UL, // Type 1 Write 1 Words to CMD
            0x000000D0UL, // SHUTDOWN Command
            0x04000000UL, // Type 1 NO OP
            0x04000000UL, // Type 1 NO OP
            0x0c000180UL, // Type 1 Write 1 Words to CMD
            0x000000E0UL, // RCRC Command
            0x04000000UL, // Type 1 NO OP
            0x04000000UL, // Type 1 NO OP
            0x04000000UL, // Type 1 NO OP
            0x04000000UL, // Type 1 NO OP
            0x04000000UL, // Type 1 NO OP
            0x04000000UL, // Type 1 NO OP
            0x04000000UL // Type 1 NO OP
        };

        for (int i = 0; i < 13; i++)
        {
            if (f[i].fd >= 0)
            {
                for (int j = 0; j < 21; j++)
                {
                    val = iprog[j];
                    mwrite(f[i].fd, &val, 4, ICAP); // write icap register
                }
            }
        }
        // board should cease to exist at this time. Reboot needed.

        log_printf("Wrote SHUTDOWN command. Power cycle the board and reboot computer to recover control FPGA\n");
        return 0;
    }

    if (command.compare("reset") == 0 && !do_control)
    {

        for (int i = 0; i < 13; i++)
        {
            if (f[i].fd >= 0)
            {
                val = 4; // unconfigure bit
                mwrite(f[i].fd, &val, 4, CONFIG_CONTROL); // configuration reset

                mread(f[i].fd, &val, 4, CONFIG_CONTROL); // read configuration status
                log_printf("pt: d: %d i: %d e: %d core: d: %d i: %d e: %d   ",
                           (val >>5)&1, (val >>4)&1, (val >>3)&1, (val >>2)&1, (val >>1)&1, val&1
                           );
                mread(f[i].fd, &val, 4, SM_STATES); // read state machine states
                log_printf("sm states: pt: %d core: %d\n", (val>>4)&0xf, val & 0xf);
            }
        }

        log_printf("done\n");
        return 0;
    }


    if (command.compare("status") == 0)
    {

        // module addresses
        uint32_t MEM_BASE = 0x80000; // 0xc0000  bytes
        uint64_t REG_BASE = 0x40ULL; // 0x60ULL  bytes
        uint32_t control_fw_version, saddr, core_fw_version;
        uint64_t value;
        off_t pos;

        for (int i = 0; i < 13; i++)
        {
            if (f[i].fd >= 0)
            {
                log_printf("device index: %d\n", i);
                mread (f[i].fd, &control_fw_version, 4, 0x1c); // read FW version from control FPGA
                uint16_t day, month, year, hour, minute, second;
                second = control_fw_version & 0x3f;
                minute = (control_fw_version >> 6)  & 0x3f;
                hour   = (control_fw_version >> 12) & 0x1f;
                year   = ((control_fw_version >> 17) & 0x3f) + 2000;
                month  = (control_fw_version >> 23) & 0xf;
                day    = (control_fw_version >> 27) & 0x1f;
                log_printf("Control FW date: %04d-%02d-%02d time: %02d:%02d:%02d\n",
                           year, month, day, hour, minute, second);

                int ch = REG_BANK_CH; // config register bank

                // read core FPGA fw version
                saddr = MEM_BASE + (ch << 12) + (0x18 << 3) ;
                pos = (REG_BASE << 32) + saddr;
                mread(f[i].fd, &value, 8, pos);
                core_fw_version = value & 0xffffffff;
                second = core_fw_version & 0x3f;
                minute = (core_fw_version >> 6)  & 0x3f;
                hour   = (core_fw_version >> 12) & 0x1f;
                year   = ((core_fw_version >> 17) & 0x3f) + 2000;
                month  = (core_fw_version >> 23) & 0xf;
                day    = (core_fw_version >> 27) & 0x1f;
                log_printf("Core    FW date: %04d-%02d-%02d time: %02d:%02d:%02d\n",
                           year, month, day, hour, minute, second);


                mread(f[i].fd, &val, 4, CONFIG_CONTROL); // read configuration status
                log_printf("core FPGA: done: %d init: %d enable: %d   ",
                           (val >>2)&1, (val >>1)&1, val&1
                           );
                mread(f[i].fd, &val, 4, SM_STATES); // read state machine states
                log_printf("State machine state: %d\n", val & 0xf);
            }
        }
        log_printf("done\n");
        return 0;
    }


    if (command.compare("stop") == 0)
    {

        val = 0;
        for (int i = 0; i < 13; i++)
        {
            if (f[i].fd >= 0)
            {
                mwrite(f[i].fd, &val, 4, CONFIG_CONTROL); // configuration start
            }
        }
        log_printf("done\n");
        return 0;
    }

    if (command.compare("status") == 0)
    {

        for (int i = 0; i < 13; i++)
        {
            if (f[i].fd >= 0)
            {
                mread(f[i].fd, &val, 4, CONFIG_CONTROL); // read configuration status
                log_printf("config status: %d\n", val);
            }
        }
        log_printf("done\n");
        return 0;
    }

    uint16_t* buffer = NULL;
    uint32_t nblocks = 0;
    string fname;
    uint32_t start_block;

    // all commands below require file, so check and read it now
    if ((!fname_core.empty() && !do_control) || (!fname_control.empty() && do_control))
    {
        if (do_control) fname = fname_control;
        else fname = fname_core;

        FILE* fin;
        fin = fopen(fname.c_str(), "rb");
        if (fin == NULL)
        {
            log_printf("file %s not found\n", fname.c_str());
            return 0xff;
        }

        // obtain file size:
        fseek (fin, 0, SEEK_END);
        long lSize = ftell (fin);
        rewind (fin);

        // make buffer size multiple of block size
        // core f/w
        long bsize = lSize;
        if (lSize % BLK_SIZE_B != 0)
            bsize = ((lSize / BLK_SIZE_B) + 1) * BLK_SIZE_B;

        // allocate memory to contain the file
        buffer = (uint16_t*) malloc (bsize);
        if (buffer == NULL) {log_printf ("Memory error\n"); return -3;}

        memset (buffer, 0, bsize);

        // start block number
        // control fw starts from 0 address, core firmware starts after reserved blocks
        start_block = (do_control) ? 0UL : BLK_RESERVED;

        // copy the file into the buffer
        // starting from block 0
        size_t result = fread (buffer, 1, lSize, fin);
        if (result != (size_t)lSize) {log_printf ("Error reading f/w file\n"); return -3;}

        // reverse bit order
        for (int i = 0; i < lSize/2; i++)
        {
            buffer[i] = r16.reverse(buffer[i]);
        }

        nblocks = bsize / BLK_SIZE_B;
        log_printf("blocks in file: %d start block: %d\n", nblocks, start_block);
        fclose (fin);
    }

    if (command.compare("erase") == 0)
    {
        // start erase threads for all selected devices
        for (int i = 0; i < 13; i++)
        {
            if (f[i].fd >= 0)
            {
                log_printf("device index: %d\n", i);
                fet[i].fp = &(f[i]); // let thread know file descriptor for this device
                fet[i].nblocks = nblocks; // block count
                fet[i].start_block = start_block; // start block
                fet[i].start(); // start erase thread for this device
            }
        }
        // wait until all threads exit
        bool threads_done;
        do
        {
            threads_done = true;
            for (int i = 0; i < 13; i++)
            {
                if (f[i].fd >= 0)
                {
                    if (!fet[i].isFinished()) threads_done = false;
                }
            }
            usleep (100000);
        } while (!threads_done);
        log_printf ("flash: all erase threads exited\n");
    }
    else if (command.compare("write") == 0)
    {
        for (int i = 0; i < 13; i++)
        {
            if (f[i].fd >= 0)
            {
                log_printf("device index: %d\n", i);
                fwt[i].fp = &(f[i]); // let thread know file descriptor for this device
                fwt[i].nblocks = nblocks; // block count
                fwt[i].start_block = start_block; // start block
                fwt[i].buffer = buffer; // data buffer
                fwt[i].start(); // start write thread for this device
            }
        }
        // wait until all threads exit
        bool threads_done;
        do
        {
            threads_done = true;
            for (int i = 0; i < 13; i++)
            {
                if (f[i].fd >= 0)
                {
                    if (!fwt[i].isFinished()) threads_done = false;
                }
            }
            usleep (100000);
        } while (!threads_done);
        log_printf ("flash: all write threads exited\n");
    }
    else if (command.compare("verify") == 0)
    {

        log_printf ("verifying\n");



        for (int i = 0; i < 13; i++)
        {
            if (f[i].fd >= 0)
            {
                log_printf("device index: %d\n", i);
                fvt[i].fp = &(f[i]); // let thread know file descriptor for this device
                fvt[i].nblocks = nblocks; // block count
                fvt[i].start_block = start_block; // start block
                fvt[i].buffer = buffer; // data buffer
                fvt[i].start(); // start write thread for this device
            }
        }
        // wait until all threads exit
        bool threads_done;
        do
        {
            threads_done = true;
            for (int i = 0; i < 13; i++)
            {
                if (f[i].fd >= 0)
                {
                    if (!fvt[i].isFinished()) threads_done = false;
                }
            }
            usleep (100000);
        } while (!threads_done);
        log_printf ("flash: all verify threads exited\n");
    }

    free(buffer);
    log_printf("done\n");
    return 0;

/*
uint16_t data[BLK_SIZE * NBLOCKS];
uint16_t rdata[BLK_SIZE * NBLOCKS];
    srandom(987);
    for (int i = 0; i < BLK_SIZE * NBLOCKS; i++)
        data[i] = random();

    f.reset_flash();

    cout << "programming" << endl;

    for (int i = 0; i < NBLOCKS; i++)
    {
        cout << "erasing block " << dec << i << endl;
        f.erase_block (i * BLK_SIZE);
    }

    for (int i = 0; i < NBLOCKS; i++)
    {
        cout << "programming block " << dec << i << endl;
        f.program_block (i * BLK_SIZE, &data[i * BLK_SIZE]);
    }

    cout << "verifying" << endl;

    int err_cnt = 0;

    f.read_block(0, rdata, BLK_SIZE * NBLOCKS);

    for (uint32_t i = 0; i < BLK_SIZE * NBLOCKS; i++)
    {

        //      val = f.read_word(i);
        val = rdata[i];
        if (val != data[i])
        {
            err_cnt++;
            if (err_cnt > 100) break;
            cout << hex << "i: " << i << " w: " << data[i] << "  r: " << val << dec << endl;
        }

    }

    return 0;
    */
}
