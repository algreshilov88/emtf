    vllut_in = $fopen({`dpath, "ge11_lut/th_mem", `fest, ".lut"}, "r");
    if (vllut_in == 0) 
    begin
        $fwrite(sim_out, {"cannot open lut file: ", `dpath, "ge11_lut/th_mem", `fest, ".lut"});
        $finish;
    end
    
// fill th LUTs
	$readmemh({`dpath, "ge11_lut/th_mem", `fest, ".lut"}, ge11_th_tmp);

    // repackage data and place into actual LUTs in the firmware
    for (wi = 0; wi < 14; wi++) // 64-bit word loop
    begin
        ge11_th_u64 = 64'h0;
        for (int wj = 0; wj < 8; wj++) // byte loop inside 64-bit word
        begin
//            $fwrite(sim_out, "GE11 th_mem: i: %2d j: %2d u8: %02h\n", wi, wj, ge11_th_tmp [wi*8+wj]);
            ge11_th_u64 [wj*8 +: 8] = ge11_th_tmp [wi*8+wj];
        end
//        $fwrite(sim_out, "GE11 th_mem: i: %2d u64: %016h\n", wi, ge11_th_u64);
        uut.pcs_ge11.th_mem.comb[wi] = ge11_th_u64;
    end

//    for (wi = 0; wi < 14; wi++) // 64-bit word loop
//    begin
//        $fwrite(sim_out, "GE11 th_mem: i: %2d u64: %016h\n", wi, uut.pcs_ge11.th_mem.comb[wi]);
//    end

// fill ph init
	$readmemh({`dpath, "ge11_lut/ph_init", `fest, ".lut"}, uut.pcs_ge11.ph_init.comb);

//    for (wi = 0; wi < 14; wi++) // 64-bit word loop
//    begin
//        $fwrite(sim_out, "GE11 ph_init: i: %2d u64: %016h\n", wi, uut.pcs_ge11.ph_init.comb[wi]);
//    end
