module dbg
(
    input pcie_clk,
    input reset,
    input            jtag_enable     ,
    output           jtag_done       ,
    input  [31 : 0 ] jtag_length     ,
    input  [31 : 0 ] jtag_tms_vector ,
    input  [31 : 0 ] jtag_tdi_vector ,
    output [31 : 0 ] jtag_tdo_vector 
);

   wire           jtag_tck        ;
   wire           jtag_tms        ;
   wire           jtag_tdi        ;
   wire           jtag_tdo        ;

    // JTAG master
    jtag_proc  
        # (.C_TCK_CLOCK_RATIO(8))
    jtag_proc_i
    (
       .CLK        (pcie_clk       ),
       .RESET      (reset          ),
       .ENABLE     (jtag_enable    ),
       .DONE       (jtag_done      ),
       .LENGTH     (jtag_length    ),
       .TMS_VECTOR (jtag_tms_vector),
       .TDI_VECTOR (jtag_tdi_vector),
       .TDO_VECTOR (jtag_tdo_vector),
       .TCK        (jtag_tck       ),
       .TMS        (jtag_tms       ),
       .TDI        (jtag_tdi       ),
       .TDO        (jtag_tdo       )
    );

    wire m0_bscan_bscanid_en ;
    wire m0_bscan_capture    ;
    wire m0_bscan_drck       ;
    wire m0_bscan_reset      ;
    wire m0_bscan_runtest    ;
    wire m0_bscan_sel        ;
    wire m0_bscan_shift      ;
    wire m0_bscan_tck        ;
    wire m0_bscan_tdi        ;
    wire m0_bscan_tdo        ;
    wire m0_bscan_tms        ;
    wire m0_bscan_update     ;

    debug_bridge_0 jtag_bscan 
    (
      .jtag_tdi            (jtag_tdi),                       
      .jtag_tdo            (jtag_tdo),                       
      .jtag_tms            (jtag_tms),                       
      .jtag_tck            (jtag_tck),                       
      .m0_bscan_bscanid_en (m0_bscan_bscanid_en), 
      .m0_bscan_capture    (m0_bscan_capture),       
      .m0_bscan_drck       (m0_bscan_drck),             
      .m0_bscan_reset      (m0_bscan_reset),           
      .m0_bscan_runtest    (m0_bscan_runtest),       
      .m0_bscan_sel        (m0_bscan_sel),               
      .m0_bscan_shift      (m0_bscan_shift),           
      .m0_bscan_tck        (m0_bscan_tck),               
      .m0_bscan_tdi        (m0_bscan_tdi),               
      .m0_bscan_tdo        (m0_bscan_tdo),               
      .m0_bscan_tms        (m0_bscan_tms),               
      .m0_bscan_update     (m0_bscan_update)          
    );
        
    debug_bridge_1 bscan_dbghub 
    (
      .clk                (pcie_clk),                              
      .S_BSCAN_bscanid_en (m0_bscan_bscanid_en),
      .S_BSCAN_capture    (m0_bscan_capture),      
      .S_BSCAN_drck       (m0_bscan_drck),            
      .S_BSCAN_reset      (m0_bscan_reset),          
      .S_BSCAN_runtest    (m0_bscan_runtest),      
      .S_BSCAN_sel        (m0_bscan_sel),              
      .S_BSCAN_shift      (m0_bscan_shift),          
      .S_BSCAN_tck        (m0_bscan_tck),              
      .S_BSCAN_tdi        (m0_bscan_tdi),              
      .S_BSCAN_tdo        (m0_bscan_tdo),              
      .S_BSCAN_tms        (m0_bscan_tms),              
      .S_BSCAN_update     (m0_bscan_update)         
    );



endmodule

