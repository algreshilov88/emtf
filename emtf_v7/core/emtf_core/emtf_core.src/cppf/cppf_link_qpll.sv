module cppf_link_qpll #
(
    parameter EXAMPLE_SIM_GTRESET_SPEEDUP            = "TRUE",     // Simulation setting for GT SecureIP model
    parameter STABLE_CLOCK_PERIOD                    = 25         //Period of the stable clock driving this state-machine, unit is [ns]

)
(
    input [2:0] refclk,
    input sysclk_in_i,
    input [2:0] qpll_reset,
    input soft_reset,
    
    output [2:0] qpll_lock,
    output [2:0] qpll_outclk,
    output [2:0] qpll_outrefclk,
    output [2:0] qpll_refclklost
  );

    wire [2:0] commonreset;  
  
    genvar gi;
    generate
        for (gi = 0; gi < 3; gi = gi+1)
        begin: qpll_loop
            cppf_link_10g_common #
            (
                .WRAPPER_SIM_GTRESET_SPEEDUP(EXAMPLE_SIM_GTRESET_SPEEDUP),
                .SIM_QPLLREFCLK_SEL(3'b010)
            )
            common0_i
            (
                .QPLLREFCLKSEL_IN(3'b010),
                .GTREFCLK0_IN(1'b0),
                .GTREFCLK1_IN(refclk[gi]),
                .QPLLLOCK_OUT(qpll_lock[gi]),
                .QPLLLOCKDETCLK_IN(sysclk_in_i),
                .QPLLOUTCLK_OUT(qpll_outclk[gi]),
                .QPLLOUTREFCLK_OUT(qpll_outrefclk[gi]),
                .QPLLREFCLKLOST_OUT(qpll_refclklost[gi]),    
                .QPLLRESET_IN(qpll_reset[gi] | commonreset[gi])
            
            );
            
            cppf_link_10g_common_reset # 
            (
                .STABLE_CLOCK_PERIOD (STABLE_CLOCK_PERIOD)        // Period of the stable clock driving this state-machine, unit is [ns]
            )
            common_reset_i
            (    
                .STABLE_CLOCK(sysclk_in_i),             //Stable Clock, either a stable clock from the PCB
                .SOFT_RESET(soft_reset),               //User Reset, can be pulled any time
                .COMMON_RESET(commonreset[gi])              //Reset QPLL
            );
        end

    endgenerate

endmodule
