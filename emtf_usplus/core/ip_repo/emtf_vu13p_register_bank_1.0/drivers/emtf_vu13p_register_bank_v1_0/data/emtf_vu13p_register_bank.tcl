

proc generate {drv_handle} {
	xdefine_include_file $drv_handle "xparameters.h" "emtf_vu13p_register_bank" "NUM_INSTANCES" "DEVICE_ID"  "C_S00_AXI_BASEADDR" "C_S00_AXI_HIGHADDR"
}
