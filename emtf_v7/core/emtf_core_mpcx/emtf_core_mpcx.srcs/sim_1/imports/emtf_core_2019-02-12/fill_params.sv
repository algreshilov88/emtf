		    vllut_in = $fopen({`dpath, "vl_lut/vl_th_corr_lut", `fes, "sub_1_st_1_ch_1.lut"}, "r");
		    if (vllut_in == 0) 
            begin
                 $fwrite(sim_out, {"cannot open lut file: ", `dpath, "vl_lut/vl_th_corr_lut", `fes, "sub_1_st_1_ch_1.lut"});
                 $finish;
            end
// fill th LUTs
			$readmemh({`dpath, "vl_lut/vl_th_corr_lut", `fes, "sub_1_st_1_ch_1.lut"}, uut.pcs.station11[0].csc11[0].pc11.th_corr_mem);
			$readmemh({`dpath, "vl_lut/vl_th_corr_lut", `fes, "sub_1_st_1_ch_2.lut"}, uut.pcs.station11[0].csc11[1].pc11.th_corr_mem);
			$readmemh({`dpath, "vl_lut/vl_th_corr_lut", `fes, "sub_1_st_1_ch_3.lut"}, uut.pcs.station11[0].csc11[2].pc11.th_corr_mem);
			$readmemh({`dpath, "vl_lut/vl_th_corr_lut", `fes, "sub_1_st_1_ch_13.lut"}, uut.pcs.pcn11.th_corr_mem);
			
			$readmemh({`dpath, "vl_lut/vl_th_corr_lut", `fes, "sub_2_st_1_ch_1.lut"}, uut.pcs.station11[1].csc11[0].pc11.th_corr_mem);
			$readmemh({`dpath, "vl_lut/vl_th_corr_lut", `fes, "sub_2_st_1_ch_2.lut"}, uut.pcs.station11[1].csc11[1].pc11.th_corr_mem);
			$readmemh({`dpath, "vl_lut/vl_th_corr_lut", `fes, "sub_2_st_1_ch_3.lut"}, uut.pcs.station11[1].csc11[2].pc11.th_corr_mem);

			$readmemh({`dpath, "vl_lut/vl_th_lut", `fes, "sub_1_st_1_ch_1.lut"}, uut.pcs.station11[0].csc11[0].pc11.th_mem);
			$readmemh({`dpath, "vl_lut/vl_th_lut", `fes, "sub_1_st_1_ch_2.lut"}, uut.pcs.station11[0].csc11[1].pc11.th_mem);
			$readmemh({`dpath, "vl_lut/vl_th_lut", `fes, "sub_1_st_1_ch_3.lut"}, uut.pcs.station11[0].csc11[2].pc11.th_mem);
			$readmemh({`dpath, "vl_lut/vl_th_lut", `fes, "sub_1_st_1_ch_4.lut"}, uut.pcs.station12[0].csc12[3].pc12.th_mem);
			$readmemh({`dpath, "vl_lut/vl_th_lut", `fes, "sub_1_st_1_ch_5.lut"}, uut.pcs.station12[0].csc12[4].pc12.th_mem);
			$readmemh({`dpath, "vl_lut/vl_th_lut", `fes, "sub_1_st_1_ch_6.lut"}, uut.pcs.station12[0].csc12[5].pc12.th_mem);
			$readmemh({`dpath, "vl_lut/vl_th_lut", `fes, "sub_1_st_1_ch_7.lut"}, uut.pcs.station12[0].csc12[6].pc12.th_mem);
			$readmemh({`dpath, "vl_lut/vl_th_lut", `fes, "sub_1_st_1_ch_8.lut"}, uut.pcs.station12[0].csc12[7].pc12.th_mem);
			$readmemh({`dpath, "vl_lut/vl_th_lut", `fes, "sub_1_st_1_ch_9.lut"}, uut.pcs.station12[0].csc12[8].pc12.th_mem);
			$readmemh({`dpath, "vl_lut/vl_th_lut", `fes, "sub_1_st_1_ch_13.lut"}, uut.pcs.pcn11.th_mem);
			$readmemh({`dpath, "vl_lut/vl_th_lut", `fes, "sub_1_st_1_ch_14.lut"}, uut.pcs.cscn[1].pcn.th_mem);
			$readmemh({`dpath, "vl_lut/vl_th_lut", `fes, "sub_1_st_1_ch_15.lut"}, uut.pcs.cscn[2].pcn.th_mem);
			
			$readmemh({`dpath, "vl_lut/vl_th_lut", `fes, "sub_2_st_1_ch_1.lut"}, uut.pcs.station11[1].csc11[0].pc11.th_mem);
			$readmemh({`dpath, "vl_lut/vl_th_lut", `fes, "sub_2_st_1_ch_2.lut"}, uut.pcs.station11[1].csc11[1].pc11.th_mem);
			$readmemh({`dpath, "vl_lut/vl_th_lut", `fes, "sub_2_st_1_ch_3.lut"}, uut.pcs.station11[1].csc11[2].pc11.th_mem);
			$readmemh({`dpath, "vl_lut/vl_th_lut", `fes, "sub_2_st_1_ch_4.lut"}, uut.pcs.station12[1].csc12[3].pc12.th_mem);
			$readmemh({`dpath, "vl_lut/vl_th_lut", `fes, "sub_2_st_1_ch_5.lut"}, uut.pcs.station12[1].csc12[4].pc12.th_mem);
			$readmemh({`dpath, "vl_lut/vl_th_lut", `fes, "sub_2_st_1_ch_6.lut"}, uut.pcs.station12[1].csc12[5].pc12.th_mem);
			$readmemh({`dpath, "vl_lut/vl_th_lut", `fes, "sub_2_st_1_ch_7.lut"}, uut.pcs.station12[1].csc12[6].pc12.th_mem);
			$readmemh({`dpath, "vl_lut/vl_th_lut", `fes, "sub_2_st_1_ch_8.lut"}, uut.pcs.station12[1].csc12[7].pc12.th_mem);
			$readmemh({`dpath, "vl_lut/vl_th_lut", `fes, "sub_2_st_1_ch_9.lut"}, uut.pcs.station12[1].csc12[8].pc12.th_mem);

			$readmemh({`dpath, "vl_lut/vl_th_lut", `fes, "st_2_ch_1.lut"}, uut.pcs.station234[2].csc[0].pc.th_mem);
			$readmemh({`dpath, "vl_lut/vl_th_lut", `fes, "st_2_ch_2.lut"}, uut.pcs.station234[2].csc[1].pc.th_mem);
			$readmemh({`dpath, "vl_lut/vl_th_lut", `fes, "st_2_ch_3.lut"}, uut.pcs.station234[2].csc[2].pc.th_mem);
			$readmemh({`dpath, "vl_lut/vl_th_lut", `fes, "st_2_ch_4.lut"}, uut.pcs.station234[2].csc[3].pc.th_mem);
			$readmemh({`dpath, "vl_lut/vl_th_lut", `fes, "st_2_ch_5.lut"}, uut.pcs.station234[2].csc[4].pc.th_mem);
			$readmemh({`dpath, "vl_lut/vl_th_lut", `fes, "st_2_ch_6.lut"}, uut.pcs.station234[2].csc[5].pc.th_mem);
			$readmemh({`dpath, "vl_lut/vl_th_lut", `fes, "st_2_ch_7.lut"}, uut.pcs.station234[2].csc[6].pc.th_mem);
			$readmemh({`dpath, "vl_lut/vl_th_lut", `fes, "st_2_ch_8.lut"}, uut.pcs.station234[2].csc[7].pc.th_mem);
			$readmemh({`dpath, "vl_lut/vl_th_lut", `fes, "st_2_ch_9.lut"}, uut.pcs.station234[2].csc[8].pc.th_mem);
			$readmemh({`dpath, "vl_lut/vl_th_lut", `fes, "st_2_ch_10.lut"}, uut.pcs.cscn[3].pcn.th_mem);
            $readmemh({`dpath, "vl_lut/vl_th_lut", `fes, "st_2_ch_11.lut"}, uut.pcs.cscn[4].pcn.th_mem);
			
			$readmemh({`dpath, "vl_lut/vl_th_lut", `fes, "st_3_ch_1.lut"}, uut.pcs.station234[3].csc[0].pc.th_mem);
			$readmemh({`dpath, "vl_lut/vl_th_lut", `fes, "st_3_ch_2.lut"}, uut.pcs.station234[3].csc[1].pc.th_mem);
			$readmemh({`dpath, "vl_lut/vl_th_lut", `fes, "st_3_ch_3.lut"}, uut.pcs.station234[3].csc[2].pc.th_mem);
			$readmemh({`dpath, "vl_lut/vl_th_lut", `fes, "st_3_ch_4.lut"}, uut.pcs.station234[3].csc[3].pc.th_mem);
			$readmemh({`dpath, "vl_lut/vl_th_lut", `fes, "st_3_ch_5.lut"}, uut.pcs.station234[3].csc[4].pc.th_mem);
			$readmemh({`dpath, "vl_lut/vl_th_lut", `fes, "st_3_ch_6.lut"}, uut.pcs.station234[3].csc[5].pc.th_mem);
			$readmemh({`dpath, "vl_lut/vl_th_lut", `fes, "st_3_ch_7.lut"}, uut.pcs.station234[3].csc[6].pc.th_mem);
			$readmemh({`dpath, "vl_lut/vl_th_lut", `fes, "st_3_ch_8.lut"}, uut.pcs.station234[3].csc[7].pc.th_mem);
			$readmemh({`dpath, "vl_lut/vl_th_lut", `fes, "st_3_ch_9.lut"}, uut.pcs.station234[3].csc[8].pc.th_mem);
			$readmemh({`dpath, "vl_lut/vl_th_lut", `fes, "st_3_ch_10.lut"}, uut.pcs.cscn[5].pcn.th_mem);
            $readmemh({`dpath, "vl_lut/vl_th_lut", `fes, "st_3_ch_11.lut"}, uut.pcs.cscn[6].pcn.th_mem);
			
			$readmemh({`dpath, "vl_lut/vl_th_lut", `fes, "st_4_ch_1.lut"}, uut.pcs.station234[4].csc[0].pc.th_mem);
			$readmemh({`dpath, "vl_lut/vl_th_lut", `fes, "st_4_ch_2.lut"}, uut.pcs.station234[4].csc[1].pc.th_mem);
			$readmemh({`dpath, "vl_lut/vl_th_lut", `fes, "st_4_ch_3.lut"}, uut.pcs.station234[4].csc[2].pc.th_mem);
			$readmemh({`dpath, "vl_lut/vl_th_lut", `fes, "st_4_ch_4.lut"}, uut.pcs.station234[4].csc[3].pc.th_mem);
			$readmemh({`dpath, "vl_lut/vl_th_lut", `fes, "st_4_ch_5.lut"}, uut.pcs.station234[4].csc[4].pc.th_mem);
			$readmemh({`dpath, "vl_lut/vl_th_lut", `fes, "st_4_ch_6.lut"}, uut.pcs.station234[4].csc[5].pc.th_mem);
			$readmemh({`dpath, "vl_lut/vl_th_lut", `fes, "st_4_ch_7.lut"}, uut.pcs.station234[4].csc[6].pc.th_mem);
			$readmemh({`dpath, "vl_lut/vl_th_lut", `fes, "st_4_ch_8.lut"}, uut.pcs.station234[4].csc[7].pc.th_mem);
			$readmemh({`dpath, "vl_lut/vl_th_lut", `fes, "st_4_ch_9.lut"}, uut.pcs.station234[4].csc[8].pc.th_mem);
			$readmemh({`dpath, "vl_lut/vl_th_lut", `fes, "st_4_ch_10.lut"}, uut.pcs.cscn[7].pcn.th_mem);
            $readmemh({`dpath, "vl_lut/vl_th_lut", `fes, "st_4_ch_11.lut"}, uut.pcs.cscn[8].pcn.th_mem);

			//$readmemh({`dpath, "vl_lut/ph_init_endcap_1_sect_6.lut"}, ph_init);
			$readmemh({`dpath, "vl_lut/th_init", `fest, ".lut"}, th_init);
			$readmemh({`dpath, "vl_lut/ph_disp", `fest, ".lut"}, ph_disp);
			$readmemh({`dpath, "vl_lut/th_disp", `fest, ".lut"}, th_disp);

			$readmemh({`dpath, "vl_lut/ph_init_full", `fest, "_st_0.lut"}, ph_init0);
			$readmemh({`dpath, "vl_lut/ph_init_full", `fest, "_st_1.lut"}, ph_init1);
			$readmemh({`dpath, "vl_lut/ph_init_full", `fest, "_st_2.lut"}, ph_init2);
			$readmemh({`dpath, "vl_lut/ph_init_full", `fest, "_st_3.lut"}, ph_init3);
			$readmemh({`dpath, "vl_lut/ph_init_full", `fest, "_st_4.lut"}, ph_init4);


            uut.pcs.station11[0].csc11[0].pc11.params[0] = ph_init0[0];   // ME11b
            uut.pcs.station11[0].csc11[0].pc11.params[1] = ph_disp[0];   // ME11b
            uut.pcs.station11[0].csc11[0].pc11.params[2] = ph_init0[0+9]; // ME11a
            uut.pcs.station11[0].csc11[0].pc11.params[3] = ph_disp[0+9]; // ME11a
            uut.pcs.station11[0].csc11[0].pc11.params[4] = th_init[0]; 
            uut.pcs.station11[0].csc11[0].pc11.params[5] = th_disp[0];

            uut.pcs.station11[0].csc11[1].pc11.params[0] = ph_init0[1];   // ME11b
            uut.pcs.station11[0].csc11[1].pc11.params[1] = ph_disp[1];   // ME11b
            uut.pcs.station11[0].csc11[1].pc11.params[2] = ph_init0[1+9]; // ME11a
            uut.pcs.station11[0].csc11[1].pc11.params[3] = ph_disp[1+9]; // ME11a
            uut.pcs.station11[0].csc11[1].pc11.params[4] = th_init[1]; 
            uut.pcs.station11[0].csc11[1].pc11.params[5] = th_disp[1];

            uut.pcs.station11[0].csc11[2].pc11.params[0] = ph_init0[2];   // ME11b
            uut.pcs.station11[0].csc11[2].pc11.params[1] = ph_disp[2];   // ME11b
            uut.pcs.station11[0].csc11[2].pc11.params[2] = ph_init0[2+9]; // ME11a
            uut.pcs.station11[0].csc11[2].pc11.params[3] = ph_disp[2+9]; // ME11a
            uut.pcs.station11[0].csc11[2].pc11.params[4] = th_init[2]; 
            uut.pcs.station11[0].csc11[2].pc11.params[5] = th_disp[2];

            uut.pcs.station12[0].csc12[ 3].pc12.params[0] = ph_init0[ 3];
            uut.pcs.station12[0].csc12[ 3].pc12.params[1] = th_init[ 3];
            uut.pcs.station12[0].csc12[ 3].pc12.params[2] = ph_disp[ 3]; 
            uut.pcs.station12[0].csc12[ 3].pc12.params[3] = th_disp[ 3];

            uut.pcs.station12[0].csc12[ 4].pc12.params[0] = ph_init0[ 4];
            uut.pcs.station12[0].csc12[ 4].pc12.params[1] = th_init[ 4];
            uut.pcs.station12[0].csc12[ 4].pc12.params[2] = ph_disp[ 4]; 
            uut.pcs.station12[0].csc12[ 4].pc12.params[3] = th_disp[ 4];

            uut.pcs.station12[0].csc12[ 5].pc12.params[0] = ph_init0[ 5];
            uut.pcs.station12[0].csc12[ 5].pc12.params[1] = th_init[ 5];
            uut.pcs.station12[0].csc12[ 5].pc12.params[2] = ph_disp[ 5]; 
            uut.pcs.station12[0].csc12[ 5].pc12.params[3] = th_disp[ 5];

            uut.pcs.station12[0].csc12[ 6].pc12.params[0] = ph_init0[ 6];
            uut.pcs.station12[0].csc12[ 6].pc12.params[1] = th_init[ 6];
            uut.pcs.station12[0].csc12[ 6].pc12.params[2] = ph_disp[ 6]; 
            uut.pcs.station12[0].csc12[ 6].pc12.params[3] = th_disp[ 6];

            uut.pcs.station12[0].csc12[ 7].pc12.params[0] = ph_init0[ 7];
            uut.pcs.station12[0].csc12[ 7].pc12.params[1] = th_init[ 7];
            uut.pcs.station12[0].csc12[ 7].pc12.params[2] = ph_disp[ 7]; 
            uut.pcs.station12[0].csc12[ 7].pc12.params[3] = th_disp[ 7];

            uut.pcs.station12[0].csc12[ 8].pc12.params[0] = ph_init0[ 8];
            uut.pcs.station12[0].csc12[ 8].pc12.params[1] = th_init[ 8];
            uut.pcs.station12[0].csc12[ 8].pc12.params[2] = ph_disp[ 8]; 
            uut.pcs.station12[0].csc12[ 8].pc12.params[3] = th_disp[ 8];

            uut.pcs.station11[1].csc11[0].pc11.params[0] = ph_init1[0];   // ME11b
            uut.pcs.station11[1].csc11[0].pc11.params[1] = ph_disp[16];   // ME11b
            uut.pcs.station11[1].csc11[0].pc11.params[2] = ph_init1[0+9]; // ME11a
            uut.pcs.station11[1].csc11[0].pc11.params[3] = ph_disp[16+9]; // ME11a
            uut.pcs.station11[1].csc11[0].pc11.params[4] = th_init[16]; 
            uut.pcs.station11[1].csc11[0].pc11.params[5] = th_disp[16];

            uut.pcs.station11[1].csc11[1].pc11.params[0] = ph_init1[1];   // ME11b
            uut.pcs.station11[1].csc11[1].pc11.params[1] = ph_disp[17];   // ME11b
            uut.pcs.station11[1].csc11[1].pc11.params[2] = ph_init1[1+9]; // ME11a
            uut.pcs.station11[1].csc11[1].pc11.params[3] = ph_disp[17+9]; // ME11a
            uut.pcs.station11[1].csc11[1].pc11.params[4] = th_init[17]; 
            uut.pcs.station11[1].csc11[1].pc11.params[5] = th_disp[17];

            uut.pcs.station11[1].csc11[2].pc11.params[0] = ph_init1[2];   // ME11b
            uut.pcs.station11[1].csc11[2].pc11.params[1] = ph_disp[18];   // ME11b
            uut.pcs.station11[1].csc11[2].pc11.params[2] = ph_init1[2+9]; // ME11a
            uut.pcs.station11[1].csc11[2].pc11.params[3] = ph_disp[18+9]; // ME11a
            uut.pcs.station11[1].csc11[2].pc11.params[4] = th_init[18]; 
            uut.pcs.station11[1].csc11[2].pc11.params[5] = th_disp[18];

            uut.pcs.station12[1].csc12[ 3].pc12.params[0] = ph_init1[ 3];
            uut.pcs.station12[1].csc12[ 3].pc12.params[1] = th_init[19];
            uut.pcs.station12[1].csc12[ 3].pc12.params[2] = ph_disp[19]; 
            uut.pcs.station12[1].csc12[ 3].pc12.params[3] = th_disp[19];

            uut.pcs.station12[1].csc12[ 4].pc12.params[0] = ph_init1[ 4];
            uut.pcs.station12[1].csc12[ 4].pc12.params[1] = th_init[20];
            uut.pcs.station12[1].csc12[ 4].pc12.params[2] = ph_disp[20]; 
            uut.pcs.station12[1].csc12[ 4].pc12.params[3] = th_disp[20];

            uut.pcs.station12[1].csc12[ 5].pc12.params[0] = ph_init1[ 5];
            uut.pcs.station12[1].csc12[ 5].pc12.params[1] = th_init[21];
            uut.pcs.station12[1].csc12[ 5].pc12.params[2] = ph_disp[21]; 
            uut.pcs.station12[1].csc12[ 5].pc12.params[3] = th_disp[21];

            uut.pcs.station12[1].csc12[ 6].pc12.params[0] = ph_init1[ 6];
            uut.pcs.station12[1].csc12[ 6].pc12.params[1] = th_init[22];
            uut.pcs.station12[1].csc12[ 6].pc12.params[2] = ph_disp[22]; 
            uut.pcs.station12[1].csc12[ 6].pc12.params[3] = th_disp[22];

            uut.pcs.station12[1].csc12[ 7].pc12.params[0] = ph_init1[ 7];
            uut.pcs.station12[1].csc12[ 7].pc12.params[1] = th_init[23];
            uut.pcs.station12[1].csc12[ 7].pc12.params[2] = ph_disp[23]; 
            uut.pcs.station12[1].csc12[ 7].pc12.params[3] = th_disp[23];

            uut.pcs.station12[1].csc12[ 8].pc12.params[0] = ph_init1[ 8];
            uut.pcs.station12[1].csc12[ 8].pc12.params[1] = th_init[24];
            uut.pcs.station12[1].csc12[ 8].pc12.params[2] = ph_disp[24]; 
            uut.pcs.station12[1].csc12[ 8].pc12.params[3] = th_disp[24];

            // neighbor sector ME1
            // ME11 single chamber
            uut.pcs.pcn11.params[0] = ph_init0[12]; // ME11b
            uut.pcs.pcn11.params[1] = ph_disp[12]; // ME11b
            uut.pcs.pcn11.params[2] = ph_init0[15]; // ME11a
            uut.pcs.pcn11.params[3] = ph_disp[15]; // ME11a
            uut.pcs.pcn11.params[4] = th_init[12];
            uut.pcs.pcn11.params[5] = th_disp[12];

            // rest of neighbor sector chambers in ME1
            uut.pcs.cscn[1].pcn.params[0] = ph_init0[1+12];
            uut.pcs.cscn[1].pcn.params[1] = th_init[13];
            uut.pcs.cscn[1].pcn.params[2] = ph_disp[13]; 
            uut.pcs.cscn[1].pcn.params[3] = th_disp[13];

            uut.pcs.cscn[2].pcn.params[0] = ph_init0[2+12];
            uut.pcs.cscn[2].pcn.params[1] = th_init[14];
            uut.pcs.cscn[2].pcn.params[2] = ph_disp[14]; 
            uut.pcs.cscn[2].pcn.params[3] = th_disp[14];
        
    			// ME234
            uut.pcs.station234[2].csc[0].pc.params[0] = ph_init2[0];
            uut.pcs.station234[2].csc[0].pc.params[1] = th_init[28];
            uut.pcs.station234[2].csc[0].pc.params[2] = ph_disp[28]; 
            uut.pcs.station234[2].csc[0].pc.params[3] = th_disp[28];
            
            uut.pcs.station234[2].csc[1].pc.params[0] = ph_init2[1];
            uut.pcs.station234[2].csc[1].pc.params[1] = th_init[29];
            uut.pcs.station234[2].csc[1].pc.params[2] = ph_disp[29]; 
            uut.pcs.station234[2].csc[1].pc.params[3] = th_disp[29];
            
            uut.pcs.station234[2].csc[2].pc.params[0] = ph_init2[2];
            uut.pcs.station234[2].csc[2].pc.params[1] = th_init[30];
            uut.pcs.station234[2].csc[2].pc.params[2] = ph_disp[30]; 
            uut.pcs.station234[2].csc[2].pc.params[3] = th_disp[30];
            
            uut.pcs.station234[2].csc[3].pc.params[0] = ph_init2[3];
            uut.pcs.station234[2].csc[3].pc.params[1] = th_init[31];
            uut.pcs.station234[2].csc[3].pc.params[2] = ph_disp[31]; 
            uut.pcs.station234[2].csc[3].pc.params[3] = th_disp[31];
            
            uut.pcs.station234[2].csc[4].pc.params[0] = ph_init2[4];
            uut.pcs.station234[2].csc[4].pc.params[1] = th_init[32];
            uut.pcs.station234[2].csc[4].pc.params[2] = ph_disp[32]; 
            uut.pcs.station234[2].csc[4].pc.params[3] = th_disp[32];
            
            uut.pcs.station234[2].csc[5].pc.params[0] = ph_init2[5];
            uut.pcs.station234[2].csc[5].pc.params[1] = th_init[33];
            uut.pcs.station234[2].csc[5].pc.params[2] = ph_disp[33]; 
            uut.pcs.station234[2].csc[5].pc.params[3] = th_disp[33];
            
            uut.pcs.station234[2].csc[6].pc.params[0] = ph_init2[6];
            uut.pcs.station234[2].csc[6].pc.params[1] = th_init[34];
            uut.pcs.station234[2].csc[6].pc.params[2] = ph_disp[34]; 
            uut.pcs.station234[2].csc[6].pc.params[3] = th_disp[34];
            
            uut.pcs.station234[2].csc[7].pc.params[0] = ph_init2[7];
            uut.pcs.station234[2].csc[7].pc.params[1] = th_init[35];
            uut.pcs.station234[2].csc[7].pc.params[2] = ph_disp[35]; 
            uut.pcs.station234[2].csc[7].pc.params[3] = th_disp[35];
            
            uut.pcs.station234[2].csc[8].pc.params[0] = ph_init2[8];
            uut.pcs.station234[2].csc[8].pc.params[1] = th_init[36];
            uut.pcs.station234[2].csc[8].pc.params[2] = ph_disp[36]; 
            uut.pcs.station234[2].csc[8].pc.params[3] = th_disp[36];

        // ME234 neighbors
            uut.pcs.cscn[2*2-1+0].pcn.params[0] = ph_init2[0+9]; 
            uut.pcs.cscn[2*2-1+0].pcn.params[1] = th_init[37]; 
            uut.pcs.cscn[2*2-1+0].pcn.params[2] = ph_disp[37]; 
            uut.pcs.cscn[2*2-1+0].pcn.params[3] = th_disp[37]; 

            uut.pcs.cscn[2*2-1+1].pcn.params[0] = ph_init2[1+9]; 
            uut.pcs.cscn[2*2-1+1].pcn.params[1] = th_init[38]; 
            uut.pcs.cscn[2*2-1+1].pcn.params[2] = ph_disp[38]; 
            uut.pcs.cscn[2*2-1+1].pcn.params[3] = th_disp[38]; 


        // ME234
            uut.pcs.station234[3].csc[0].pc.params[0] = ph_init3[0];
            uut.pcs.station234[3].csc[0].pc.params[1] = th_init[39];
            uut.pcs.station234[3].csc[0].pc.params[2] = ph_disp[39]; 
            uut.pcs.station234[3].csc[0].pc.params[3] = th_disp[39];
            
            uut.pcs.station234[3].csc[1].pc.params[0] = ph_init3[1];
            uut.pcs.station234[3].csc[1].pc.params[1] = th_init[40];
            uut.pcs.station234[3].csc[1].pc.params[2] = ph_disp[40]; 
            uut.pcs.station234[3].csc[1].pc.params[3] = th_disp[40];
            
            uut.pcs.station234[3].csc[2].pc.params[0] = ph_init3[2];
            uut.pcs.station234[3].csc[2].pc.params[1] = th_init[41];
            uut.pcs.station234[3].csc[2].pc.params[2] = ph_disp[41]; 
            uut.pcs.station234[3].csc[2].pc.params[3] = th_disp[41];
            
            uut.pcs.station234[3].csc[3].pc.params[0] = ph_init3[3];
            uut.pcs.station234[3].csc[3].pc.params[1] = th_init[42];
            uut.pcs.station234[3].csc[3].pc.params[2] = ph_disp[42]; 
            uut.pcs.station234[3].csc[3].pc.params[3] = th_disp[42];
            
            uut.pcs.station234[3].csc[4].pc.params[0] = ph_init3[4];
            uut.pcs.station234[3].csc[4].pc.params[1] = th_init[43];
            uut.pcs.station234[3].csc[4].pc.params[2] = ph_disp[43]; 
            uut.pcs.station234[3].csc[4].pc.params[3] = th_disp[43];
            
            uut.pcs.station234[3].csc[5].pc.params[0] = ph_init3[5];
            uut.pcs.station234[3].csc[5].pc.params[1] = th_init[44];
            uut.pcs.station234[3].csc[5].pc.params[2] = ph_disp[44]; 
            uut.pcs.station234[3].csc[5].pc.params[3] = th_disp[44];
            
            uut.pcs.station234[3].csc[6].pc.params[0] = ph_init3[6];
            uut.pcs.station234[3].csc[6].pc.params[1] = th_init[45];
            uut.pcs.station234[3].csc[6].pc.params[2] = ph_disp[45]; 
            uut.pcs.station234[3].csc[6].pc.params[3] = th_disp[45];
            
            uut.pcs.station234[3].csc[7].pc.params[0] = ph_init3[7];
            uut.pcs.station234[3].csc[7].pc.params[1] = th_init[46];
            uut.pcs.station234[3].csc[7].pc.params[2] = ph_disp[46]; 
            uut.pcs.station234[3].csc[7].pc.params[3] = th_disp[46];
            
            uut.pcs.station234[3].csc[8].pc.params[0] = ph_init3[8];
            uut.pcs.station234[3].csc[8].pc.params[1] = th_init[47];
            uut.pcs.station234[3].csc[8].pc.params[2] = ph_disp[47]; 
            uut.pcs.station234[3].csc[8].pc.params[3] = th_disp[47];

        // ME234 neighbors
            uut.pcs.cscn[3*2-1+0].pcn.params[0] = ph_init3[0+9]; 
            uut.pcs.cscn[3*2-1+0].pcn.params[1] = th_init[48]; 
            uut.pcs.cscn[3*2-1+0].pcn.params[2] = ph_disp[48]; 
            uut.pcs.cscn[3*2-1+0].pcn.params[3] = th_disp[48]; 

            uut.pcs.cscn[3*2-1+1].pcn.params[0] = ph_init3[1+9]; 
            uut.pcs.cscn[3*2-1+1].pcn.params[1] = th_init[49]; 
            uut.pcs.cscn[3*2-1+1].pcn.params[2] = ph_disp[49]; 
            uut.pcs.cscn[3*2-1+1].pcn.params[3] = th_disp[49]; 


        // ME234
            uut.pcs.station234[4].csc[0].pc.params[0] = ph_init4[0];
            uut.pcs.station234[4].csc[0].pc.params[1] = th_init[50];
            uut.pcs.station234[4].csc[0].pc.params[2] = ph_disp[50]; 
            uut.pcs.station234[4].csc[0].pc.params[3] = th_disp[50];
            
            uut.pcs.station234[4].csc[1].pc.params[0] = ph_init4[1];
            uut.pcs.station234[4].csc[1].pc.params[1] = th_init[51];
            uut.pcs.station234[4].csc[1].pc.params[2] = ph_disp[51]; 
            uut.pcs.station234[4].csc[1].pc.params[3] = th_disp[51];
            
            uut.pcs.station234[4].csc[2].pc.params[0] = ph_init4[2];
            uut.pcs.station234[4].csc[2].pc.params[1] = th_init[52];
            uut.pcs.station234[4].csc[2].pc.params[2] = ph_disp[52]; 
            uut.pcs.station234[4].csc[2].pc.params[3] = th_disp[52];
            
            uut.pcs.station234[4].csc[3].pc.params[0] = ph_init4[3];
            uut.pcs.station234[4].csc[3].pc.params[1] = th_init[53];
            uut.pcs.station234[4].csc[3].pc.params[2] = ph_disp[53]; 
            uut.pcs.station234[4].csc[3].pc.params[3] = th_disp[53];
            
            uut.pcs.station234[4].csc[4].pc.params[0] = ph_init4[4];
            uut.pcs.station234[4].csc[4].pc.params[1] = th_init[54];
            uut.pcs.station234[4].csc[4].pc.params[2] = ph_disp[54]; 
            uut.pcs.station234[4].csc[4].pc.params[3] = th_disp[54];
            
            uut.pcs.station234[4].csc[5].pc.params[0] = ph_init4[5];
            uut.pcs.station234[4].csc[5].pc.params[1] = th_init[55];
            uut.pcs.station234[4].csc[5].pc.params[2] = ph_disp[55]; 
            uut.pcs.station234[4].csc[5].pc.params[3] = th_disp[55];
            
            uut.pcs.station234[4].csc[6].pc.params[0] = ph_init4[6];
            uut.pcs.station234[4].csc[6].pc.params[1] = th_init[56];
            uut.pcs.station234[4].csc[6].pc.params[2] = ph_disp[56]; 
            uut.pcs.station234[4].csc[6].pc.params[3] = th_disp[56];
            
            uut.pcs.station234[4].csc[7].pc.params[0] = ph_init4[7];
            uut.pcs.station234[4].csc[7].pc.params[1] = th_init[57];
            uut.pcs.station234[4].csc[7].pc.params[2] = ph_disp[57]; 
            uut.pcs.station234[4].csc[7].pc.params[3] = th_disp[57];
            
            uut.pcs.station234[4].csc[8].pc.params[0] = ph_init4[8];
            uut.pcs.station234[4].csc[8].pc.params[1] = th_init[58];
            uut.pcs.station234[4].csc[8].pc.params[2] = ph_disp[58]; 
            uut.pcs.station234[4].csc[8].pc.params[3] = th_disp[58];

        // ME234 neighbors
            uut.pcs.cscn[4*2-1+0].pcn.params[0] = ph_init4[0+9]; 
            uut.pcs.cscn[4*2-1+0].pcn.params[1] = th_init[59]; 
            uut.pcs.cscn[4*2-1+0].pcn.params[2] = ph_disp[59]; 
            uut.pcs.cscn[4*2-1+0].pcn.params[3] = th_disp[59]; 

            uut.pcs.cscn[4*2-1+1].pcn.params[0] = ph_init4[1+9]; 
            uut.pcs.cscn[4*2-1+1].pcn.params[1] = th_init[60]; 
            uut.pcs.cscn[4*2-1+1].pcn.params[2] = ph_disp[60]; 
            uut.pcs.cscn[4*2-1+1].pcn.params[3] = th_disp[60]; 


			
