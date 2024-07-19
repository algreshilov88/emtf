#include <iostream>
#include <iomanip>
#include <string.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/time.h>
#include <stdint.h>
#include <stdio.h>
#include <time.h>
#include <inttypes.h>
#include "sp12_macros.h"



int me11a_index[] =
{
    0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,1,
    0,0,0,0,0,0,0,0,0,1,1,1,
    0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0
};


void write_verify_pc_luts(bool verify, int endcap[13], int sector[13])
{
    int mismatch_cnt;

    for (int id = 0; id < 13; id++)
    {
        if (devices_d[id] >= 0)
        {
            int fd = devices_d[id];
            log_printf ("device index: %d\n", id);
            // file name templates
            std::string th_lut_fname[] =
            {
                "vl_lut/vl_th_lut_endcap_E_sec_S_sub_1_st_1_ch_1.lut",
                "vl_lut/vl_th_lut_endcap_E_sec_S_sub_1_st_1_ch_2.lut",
                "vl_lut/vl_th_lut_endcap_E_sec_S_sub_1_st_1_ch_3.lut",
                "vl_lut/vl_th_lut_endcap_E_sec_S_sub_1_st_1_ch_4.lut",
                "vl_lut/vl_th_lut_endcap_E_sec_S_sub_1_st_1_ch_5.lut",
                "vl_lut/vl_th_lut_endcap_E_sec_S_sub_1_st_1_ch_6.lut",
                "vl_lut/vl_th_lut_endcap_E_sec_S_sub_1_st_1_ch_7.lut",
                "vl_lut/vl_th_lut_endcap_E_sec_S_sub_1_st_1_ch_8.lut",
                "vl_lut/vl_th_lut_endcap_E_sec_S_sub_1_st_1_ch_9.lut",

                "vl_lut/vl_th_lut_endcap_E_sec_S_sub_2_st_1_ch_1.lut",
                "vl_lut/vl_th_lut_endcap_E_sec_S_sub_2_st_1_ch_2.lut",
                "vl_lut/vl_th_lut_endcap_E_sec_S_sub_2_st_1_ch_3.lut",
                "vl_lut/vl_th_lut_endcap_E_sec_S_sub_2_st_1_ch_4.lut",
                "vl_lut/vl_th_lut_endcap_E_sec_S_sub_2_st_1_ch_5.lut",
                "vl_lut/vl_th_lut_endcap_E_sec_S_sub_2_st_1_ch_6.lut",
                "vl_lut/vl_th_lut_endcap_E_sec_S_sub_2_st_1_ch_7.lut",
                "vl_lut/vl_th_lut_endcap_E_sec_S_sub_2_st_1_ch_8.lut",
                "vl_lut/vl_th_lut_endcap_E_sec_S_sub_2_st_1_ch_9.lut",

                "vl_lut/vl_th_lut_endcap_E_sec_S_st_2_ch_1.lut",
                "vl_lut/vl_th_lut_endcap_E_sec_S_st_2_ch_2.lut",
                "vl_lut/vl_th_lut_endcap_E_sec_S_st_2_ch_3.lut",
                "vl_lut/vl_th_lut_endcap_E_sec_S_st_2_ch_4.lut",
                "vl_lut/vl_th_lut_endcap_E_sec_S_st_2_ch_5.lut",
                "vl_lut/vl_th_lut_endcap_E_sec_S_st_2_ch_6.lut",
                "vl_lut/vl_th_lut_endcap_E_sec_S_st_2_ch_7.lut",
                "vl_lut/vl_th_lut_endcap_E_sec_S_st_2_ch_8.lut",
                "vl_lut/vl_th_lut_endcap_E_sec_S_st_2_ch_9.lut",

                "vl_lut/vl_th_lut_endcap_E_sec_S_st_3_ch_1.lut",
                "vl_lut/vl_th_lut_endcap_E_sec_S_st_3_ch_2.lut",
                "vl_lut/vl_th_lut_endcap_E_sec_S_st_3_ch_3.lut",
                "vl_lut/vl_th_lut_endcap_E_sec_S_st_3_ch_4.lut",
                "vl_lut/vl_th_lut_endcap_E_sec_S_st_3_ch_5.lut",
                "vl_lut/vl_th_lut_endcap_E_sec_S_st_3_ch_6.lut",
                "vl_lut/vl_th_lut_endcap_E_sec_S_st_3_ch_7.lut",
                "vl_lut/vl_th_lut_endcap_E_sec_S_st_3_ch_8.lut",
                "vl_lut/vl_th_lut_endcap_E_sec_S_st_3_ch_9.lut",

                "vl_lut/vl_th_lut_endcap_E_sec_S_st_4_ch_1.lut",
                "vl_lut/vl_th_lut_endcap_E_sec_S_st_4_ch_2.lut",
                "vl_lut/vl_th_lut_endcap_E_sec_S_st_4_ch_3.lut",
                "vl_lut/vl_th_lut_endcap_E_sec_S_st_4_ch_4.lut",
                "vl_lut/vl_th_lut_endcap_E_sec_S_st_4_ch_5.lut",
                "vl_lut/vl_th_lut_endcap_E_sec_S_st_4_ch_6.lut",
                "vl_lut/vl_th_lut_endcap_E_sec_S_st_4_ch_7.lut",
                "vl_lut/vl_th_lut_endcap_E_sec_S_st_4_ch_8.lut",
                "vl_lut/vl_th_lut_endcap_E_sec_S_st_4_ch_9.lut",

                // neighbor sector chambers
                "vl_lut/vl_th_lut_endcap_E_sec_S_sub_1_st_1_ch_13.lut",
                "vl_lut/vl_th_lut_endcap_E_sec_S_sub_1_st_1_ch_14.lut",
                "vl_lut/vl_th_lut_endcap_E_sec_S_sub_1_st_1_ch_15.lut",
                "vl_lut/vl_th_lut_endcap_E_sec_S_st_2_ch_10.lut",
                "vl_lut/vl_th_lut_endcap_E_sec_S_st_2_ch_11.lut",
                "vl_lut/vl_th_lut_endcap_E_sec_S_st_3_ch_10.lut",
                "vl_lut/vl_th_lut_endcap_E_sec_S_st_3_ch_11.lut",
                "vl_lut/vl_th_lut_endcap_E_sec_S_st_4_ch_10.lut",
                "vl_lut/vl_th_lut_endcap_E_sec_S_st_4_ch_11.lut"
            };


            std::string th_corr_fname[] =
            {
                "vl_lut/vl_th_corr_lut_endcap_E_sec_S_sub_1_st_1_ch_1.lut",
                "vl_lut/vl_th_corr_lut_endcap_E_sec_S_sub_1_st_1_ch_2.lut",
                "vl_lut/vl_th_corr_lut_endcap_E_sec_S_sub_1_st_1_ch_3.lut",
                "vl_lut/vl_th_corr_lut_endcap_E_sec_S_sub_2_st_1_ch_1.lut",
                "vl_lut/vl_th_corr_lut_endcap_E_sec_S_sub_2_st_1_ch_2.lut",
                "vl_lut/vl_th_corr_lut_endcap_E_sec_S_sub_2_st_1_ch_3.lut",
                // neighbor sector
                "vl_lut/vl_th_corr_lut_endcap_E_sec_S_sub_1_st_1_ch_13.lut"
            };

            std::string ph_init_fname[] =
            {
                "vl_lut/ph_init_full_endcap_E_sect_S_st_0.lut",
                "vl_lut/ph_init_full_endcap_E_sect_S_st_1.lut",
                "vl_lut/ph_init_full_endcap_E_sect_S_st_2.lut",
                "vl_lut/ph_init_full_endcap_E_sect_S_st_3.lut",
                "vl_lut/ph_init_full_endcap_E_sect_S_st_4.lut"
            };

            std::string th_init_fname = "vl_lut/th_init_endcap_E_sect_S.lut";
            std::string ph_disp_fname = "vl_lut/ph_disp_endcap_E_sect_S.lut";
            std::string th_disp_fname = "vl_lut/th_disp_endcap_E_sect_S.lut";

            std::string endcap_string(1, (char)endcap[id] + '0');
            std::string sector_string(1, (char)sector[id] + '0');

            // rework file names for selected endcap and sector
            for (int i = 0; i < 54; i++)
            {
                th_lut_fname[i].replace(th_lut_fname[i].find("E"), 1, endcap_string);
                th_lut_fname[i].replace(th_lut_fname[i].find("S"), 1, sector_string);
            }

            for (int i = 0; i < 7; i++)
            {
                th_corr_fname[i].replace(th_corr_fname[i].find("E"), 1, endcap_string);
                th_corr_fname[i].replace(th_corr_fname[i].find("S"), 1, sector_string);
            }

            for (int i = 0; i < 5; i++)
            {
                ph_init_fname[i].replace(ph_init_fname[i].find("E"), 1, endcap_string);
                ph_init_fname[i].replace(ph_init_fname[i].find("S"), 1, sector_string);
            }

            th_init_fname.replace(th_init_fname.find("E"), 1, endcap_string);
            th_init_fname.replace(th_init_fname.find("S"), 1, sector_string);

            ph_disp_fname.replace(ph_disp_fname.find("E"), 1, endcap_string);
            ph_disp_fname.replace(ph_disp_fname.find("S"), 1, sector_string);

            th_disp_fname.replace(th_disp_fname.find("E"), 1, endcap_string);
            th_disp_fname.replace(th_disp_fname.find("S"), 1, sector_string);

            //    int fd = device_d;
            mismatch_cnt = 0;

            //log_printf("writing & verifying LCT converter LUTs\n");
            //log_printf ("RESET CORE LINK BEFORE RUNNING THIS PROCEDURE\n");

            log_printf ("ph_init_fname : %s\n", ph_init_fname[0].c_str());

            // loopback module addresses
            uint32_t MEM_BASE = 0x80000; // 0xc0000 // bytes
//            uint64_t REG_BASE = 0x40ULL; // 0x60ULL // bytes
            uint64_t REG_BASE = 0x0ULL;

            uint64_t cid[2];

            // read chamber IDs first
            for  (int ch = 0; ch < 54; ch++) // chamber loop
            {
                // form start address {chamber[6], sel[2], addr[7], 3'b0}
                uint32_t saddr = MEM_BASE + (ch << 12) + (3 << 10); // sel = 3 for chamber ID

                // read word from LUT. Size is in bytes
//                off_t pos = (REG_BASE << 32) + saddr;
                mread(fd, cid, 8*2, saddr);

//                log_printf ("ch: %02d chamber ID: %02llx %02llx\n", ch, cid[0], cid[1]);
            }


            // **********************************************************
            // theta LUTs

            long long unsigned th_lut_data[54][128];
            long long unsigned th_lut_rb[54][128];
            int th_lut_size[54];

            // read theta luts from files first
            for (int ch = 0; ch < 54; ch++) // chamber loop, according to th_lut_fname array
            {
                // read file for this chamber
                FILE* thin = fopen (th_lut_fname[ch].c_str(), "r");
                if (thin != NULL)
                {
                    for (int i = 0; i < 128; i++)
                    {
                        int rsp = fscanf (thin, "%llx", &(th_lut_data[ch][i]));
                        if (rsp != 1)
                        {
                            th_lut_size[ch] = i; // remember size of each LUT
                            //log_printf("file %s read %d words\n", th_lut_fname[ch].c_str(), i);
                            break;
                        }
                    }
                    fclose (thin);
                }
                else
                {
                    log_printf("cannot open file %s\n", th_lut_fname[ch].c_str());
                }
            }

            // write theta luts
            if (!verify)
            {
                for (int ch = 0; ch < 54; ch++) // chamber loop, according to th_lut_fname array
                {
                    // form start address {chamber[6], sel[2], addr[7], 3'b0}
                    uint32_t saddr = MEM_BASE + (ch << 12) + (1 << 10); // sel = 1 for th_lut, addr = 0 at start

                    // write words into LUT. Size is in bytes
                    mwrite(fd, th_lut_data[ch], th_lut_size[ch]*8, saddr);
                }
                //log_printf ("theta LUTs written\n");
            }

            // **********************************************************
            // theta correction LUTs

            long long unsigned th_corr_data[7][128];
            long long unsigned th_corr_rb[7][128];
            int th_corr_size[7];

            // read theta luts from files first
            for (int ch = 0; ch < 7; ch++) // chamber loop, according to th_corr_fname array
            {
                // read file for this chamber
                FILE* thin = fopen (th_corr_fname[ch].c_str(), "r");
                if (thin != NULL)
                {
                    for (int i = 0; i < 128; i++)
                    {
                        int rsp = fscanf (thin, "%llx", &(th_corr_data[ch][i]));
                        if (rsp != 1)
                        {
                            th_corr_size[ch] = i; // remember size of each LUT
                            //log_printf("file %s read %d words\n", th_corr_fname[ch].c_str(), i);
                            break;
                        }
                    }
                    fclose (thin);
                }
                else
                {
                   log_printf("cannot open file %s\n", th_corr_fname[ch].c_str());
                }
            }

            int real_me11[] = {0,1,2,9,10,11,45};
            // write theta luts
            if (!verify)
            {
                for (int ch = 0; ch < 7; ch++) // chamber loop, according to th_corr_fname array
                {
                    // form start address {chamber[6], sel[2], addr[7], 3'b0}
                    int real_ch = real_me11[ch]; // ME1/1 chambers are 0,1,2,9,10,11,45
                    uint32_t saddr = MEM_BASE + (real_ch << 12) + (2 << 10); // sel = 2 for th_corr, addr = 0 at start

                    // write words into LUT. Size is in bytes
                    mwrite(fd, th_corr_data[ch], th_corr_size[ch]*8, saddr);
                }
                //log_printf ("theta correction LUTs written\n");
            }


            //**********************************************************
            // init parameters and displacements

            long long unsigned ph_init_data[61];
            long long unsigned ph_init_rb[61];
            //int ph_init_size;

            // read phi init parameters from files
            int di = 0;
            for (int st = 0; st < 5; st++) // station loop, according to ph_init_fname array
            {
                // read file for this station
                FILE* thin = fopen (ph_init_fname[st].c_str(), "r");
                if (thin != NULL)
                {
                    for (int i = 0; i < 128; i++)
                    {
                        int rsp = fscanf (thin, "%llx", &(ph_init_data[di]));
                        if (rsp != 1)
                        {
                            //log_printf("file %s read %d words\n", ph_init_fname[st].c_str(), i);
                            break;
                        }
                        else
                            di++;
                    }
                    fclose (thin);
                }
                else
                {
                   log_printf("cannot open file %s\n", ph_init_fname[st].c_str());
                }
            }
            //ph_init_size = di;
           //log_printf ("total ph_init words read: %d\n", ph_init_size);


            std::string* init_disp_fname[] = {&th_init_fname, &ph_disp_fname, &th_disp_fname};
            uint64_t th_init_data[61], ph_disp_data[61], th_disp_data[61];
            uint64_t* init_disp_data[] = {th_init_data, ph_disp_data, th_disp_data};
            //int init_disp_size[3];

            // read th init and ph,th displacements
            for (int fn = 0; fn < 3; fn++) // file loop
            {
                // read file for this station
                FILE* thin = fopen (init_disp_fname[fn]->c_str(), "r");
                if (thin != NULL)
                {
                    for (int i = 0; i < 128; i++)
                    {
                        int rsp = fscanf (thin, "%lx", &(init_disp_data[fn][i]));
                        //                int rsp = fscanf (thin, "%" SCNx64, &(init_disp_data[fn][i]));
                        if (rsp != 1)
                        {
						  //init_disp_size[fn] = i; // remember size of each file
                            //log_printf("file %s read %d words\n", init_disp_fname[fn]->c_str(), i);
                            break;
                        }
                    }
                    fclose (thin);
                }
                else
                {
                    log_printf("cannot open file %s\n", init_disp_fname[fn]->c_str());
                }
            }

            int me11b_cham[] = {0, 1, 2, 16,17,18, 12}; // me11b chamber indexes in files
            int me11a_cham[] = {9,10,11, 25,26,27, 15}; // me11a chamber indexes in files
            int me11_cs[]   =  {0, 1, 2,  9,10,11, 45}; // me11 chamber select bits

            if (!verify)
            {
                for (int ch = 0; ch < 7; ch++) // ME1/1 chamber loop
                {
                    // form start address {chamber[6], sel[2], addr[7], 3'b0}
                    int real_ch_a = me11a_cham[ch]; // ME1/1a chamber index
                    int real_ch_b = me11b_cham[ch]; // ME1/1b chamber index
                    uint32_t saddr = MEM_BASE + (me11_cs[ch] << 12); // sel = 0 for parameters, addr = 0 at start

                    // write words into LUT. Size is in bytes
                    mwrite(fd, &ph_init_data[real_ch_b], 8, saddr); saddr += 8; // ME1/1b
                    mwrite(fd, &ph_disp_data[real_ch_b], 8, saddr); saddr += 8; // ME1/1b
                    mwrite(fd, &ph_init_data[real_ch_a], 8, saddr); saddr += 8; // ME1/1a
                    mwrite(fd, &ph_disp_data[real_ch_a], 8, saddr); saddr += 8; // ME1/1a
                    mwrite(fd, &th_init_data[real_ch_b], 8, saddr); saddr += 8;
                    mwrite(fd, &th_disp_data[real_ch_b], 8, saddr);
                }
            }
            int other_cham[] =
            {
                 3, 4, 5, 6, 7, 8,13,14, // me1 sub 1
                19,20,21,22,23,24, // me1 sub 2
                28,29,30,31,32,33,34,35,36,37,38, // me2
                39,40,41,42,43,44,45,46,47,48,49, // me3
                50,51,52,53,54,55,56,57,58,59,60  // me4

            }; // other chamber indexes in files

            int other_cs[] =
            {
                 3, 4, 5, 6, 7, 8,46,47, // me1 sub 1
                12,13,14,15,16,17,
                18,19,20,21,22,23,24,25,26,48,49,
                27,28,29,30,31,32,33,34,35,50,51,
                36,37,38,39,40,41,42,43,44,52,53

            }; // other chamber select bits

            if (!verify)
            {
                for (int ch = 0; ch < 47 ; ch++) // other chambers loop
                {
                    // form start address {chamber[6], sel[2], addr[7], 3'b0}
                    int real_ch = other_cham[ch]; // other chambers
                    uint32_t saddr = MEM_BASE + (other_cs[ch] << 12); // sel = 0 for parameters, addr = 0 at start

                    // write words into LUT. Size is in bytes
                    mwrite(fd, &ph_init_data[real_ch], 8, saddr); saddr += 8;
                    mwrite(fd, &th_init_data[real_ch], 8, saddr); saddr += 8;
                    mwrite(fd, &ph_disp_data[real_ch], 8, saddr); saddr += 8;
                    mwrite(fd, &th_disp_data[real_ch], 8, saddr);
                }

               // log_printf ("init and displacement parameters written\n");
            }




            // **************************************************************
            // verification

            // read theta LUTs back
            //log_printf ("theta LUT verification\n");
            for (int ch = 0; ch < 54; ch++) // chamber loop, according to th_lut_fname array
            {
                // form start address {chamber[6], sel[2], addr[7], 3'b0}
                uint32_t saddr = MEM_BASE + (ch << 12) + (1 << 10); // sel = 1 for th_lut, addr = 0 at start

                // read words from LUT. Size is in bytes
                mread(fd, &(th_lut_rb[ch]), th_lut_size[ch]*8, saddr);

                // compare
                for (int i = 0; i < th_lut_size[ch]; i++)
                {
                    uint64_t xorm = th_lut_data[ch][i] ^ th_lut_rb[ch][i];
                    if (xorm != 0)
                    {
                        log_printf ("ch: %02d i: %03d w: %08x r: %08x e: %08x\n",
                                    ch, i, th_lut_data[ch][i], th_lut_rb[ch][i], xorm);
                        mismatch_cnt++;
                        if (mismatch_cnt > 200) goto eject;
                    }
                }
            }
           log_printf ("theta LUTs read and verified\n");

            // read theta correction LUTs back
            //log_printf ("theta correction LUT verification\n");
            for (int ch = 0; ch < 7; ch++) // chamber loop, according to th_corr_fname array
            {
                // form start address {chamber[6], sel[2], addr[7], 3'b0}
                int real_ch = real_me11[ch]; // ME1/1 chambers are 0,1,2,9,10,11,45
                uint32_t saddr = MEM_BASE + (real_ch << 12) + (2 << 10); // sel = 2 for th_corr, addr = 0 at start

                // read words from LUT. Size is in bytes
                off_t pos = (REG_BASE << 32) + saddr;
                mread(fd, &(th_corr_rb[ch]), th_corr_size[ch]*8, pos);

                // compare
                for (int i = 0; i < th_corr_size[ch]; i++)
                {
                    uint64_t xorm = th_corr_data[ch][i] ^ th_corr_rb[ch][i];
                    if (xorm != 0)
                    {
                        log_printf ("ch: %02d i: %03d w: %08x r: %08x e: %08x\n",
                                    ch, i, th_corr_data[ch][i], th_corr_rb[ch][i], xorm);
                        mismatch_cnt++;
                        if (mismatch_cnt > 200) goto eject;
                    }
                }
            }
            log_printf ("theta correction LUTs read and verified\n");

            //log_printf ("parameter verification\n");

            uint64_t th_init_rb[61], ph_disp_rb[61], th_disp_rb[61];
            for (int ch = 0; ch < 7; ch++) // ME1/1 chamber loop
            {
                // form start address {chamber[6], sel[2], addr[7], 3'b0}
                int real_ch_a = me11a_cham[ch]; // ME1/1a chamber index
                int real_ch_b = me11b_cham[ch]; // ME1/1b chamber index
                uint32_t saddr = MEM_BASE + (me11_cs[ch] << 12); // sel = 0 for parameters, addr = 0 at start

                off_t pos = saddr;
                // write words into LUT. Size is in bytes
                mread(fd, &ph_init_rb[real_ch_b], 8, pos); pos += 8; // ME1/1b
                mread(fd, &ph_disp_rb[real_ch_b], 8, pos); pos += 8; // ME1/1b
                mread(fd, &ph_init_rb[real_ch_a], 8, pos); pos += 8; // ME1/1a
                mread(fd, &ph_disp_rb[real_ch_a], 8, pos); pos += 8; // ME1/1a
                mread(fd, &th_init_rb[real_ch_b], 8, pos); pos += 8;
                mread(fd, &th_disp_rb[real_ch_b], 8, pos);
            }

            for (int ch = 0; ch < 47 ; ch++) // other chambers loop
            {
                // form start address {chamber[6], sel[2], addr[7], 3'b0}
                int real_ch = other_cham[ch]; // other chambers
                uint32_t saddr = MEM_BASE + (other_cs[ch] << 12); // sel = 0 for parameters, addr = 0 at start

                off_t pos = saddr;
                // write words into LUT. Size is in bytes
                mread(fd, &ph_init_rb[real_ch], 8, pos); pos += 8;
                mread(fd, &th_init_rb[real_ch], 8, pos); pos += 8;
                mread(fd, &ph_disp_rb[real_ch], 8, pos); pos += 8;
                mread(fd, &th_disp_rb[real_ch], 8, pos);
            }


            // parameter comparison
            for (int i = 0; i < 61; i++) // chamber loop
            {
                uint64_t xorm = ph_init_data[i] ^ ph_init_rb[i];
                if (xorm != 0)
                {
                    log_printf ("ph_init ch: %02d w: %08x r: %08x e: %08x\n",
                                i, ph_init_data[i], ph_init_rb[i], xorm);
                    mismatch_cnt++;
                    if (mismatch_cnt > 200) goto eject;

                }
                xorm = ph_disp_data[i] ^ ph_disp_rb[i];
                if (xorm != 0)
                {
                    log_printf ("ph_disp ch: %02d w: %08x r: %08x e: %08x\n",
                                i, ph_disp_data[i], ph_disp_rb[i], xorm);
                    mismatch_cnt++;
                    if (mismatch_cnt > 200) goto eject;

                }
                xorm = th_init_data[i] ^ th_init_rb[i];
                if (xorm != 0 && (!me11a_index[i])) // exclude ME11a from comparison
                {
                    log_printf ("th_init ch: %02d w: %08x r: %08x e: %08x\n",
                                i, th_init_data[i], th_init_rb[i], xorm);
                    mismatch_cnt++;
                    if (mismatch_cnt > 200) goto eject;

                }
                xorm = th_disp_data[i] ^ th_disp_rb[i];
                if (xorm != 0 && (!me11a_index[i])) // exclude ME11a from comparison
                {
                    log_printf ("th_disp ch: %02d w: %08x r: %08x e: %08x\n",
                                i, th_disp_data[i], th_disp_rb[i], xorm);
                    mismatch_cnt++;
                    if (mismatch_cnt > 200) goto eject;

                }
            }

            log_printf ("init and displacement parameters read and verified\n");
        }
    }
eject:

    log_printf("Mismatched words: %d\n", mismatch_cnt);

    return;
}
